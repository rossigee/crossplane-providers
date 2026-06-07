# Crossplane Provider Introspection and Drift Detection

## Overview

This document describes the standard pattern for implementing **read-only introspection** and **drift detection** in Crossplane providers. All providers should implement this pattern to enable:

1. **Import Existing Resources**: Discover and import resources that already exist in the external system without creating new ones
2. **Drift Detection**: Detect when the actual state of an external resource differs from the desired state defined in Kubernetes

## Standard Pattern: ExternalClient Interface

Crossplane providers should use the Crossplane Runtime's `managed.ExternalClient` interface, which defines three key methods:

```go
type ExternalClient interface {
    // Observe checks if the external resource exists and returns its current state
    Observe(ctx context.Context, mg resource.Managed) (ExternalObservation, error)
    
    // Create creates the external resource
    Create(ctx context.Context, mg resource.Managed) (ExternalCreation, error)
    
    // Update updates the external resource to match desired state
    Update(ctx context.Context, mg resource.Managed) (ExternalUpdate, error)
    
    // Delete removes the external resource
    Delete(ctx context.Context, mg resource.Managed) (ExternalDeletion, error)
}
```

## Required: Observe Method

The `Observe` method is the core of introspection and drift detection. It must:

1. **Query the external API** to check if the resource exists
2. **Return `ResourceExists`**: Indicates whether the resource was found
3. **Return `ResourceUpToDate`**: Indicates whether drift exists between desired and actual state

### Required Return Values

```go
func (e *external) Observe(ctx context.Context, mg resource.Managed) (managed.ExternalObservation, error) {
    cr := mg.(*YourResourceType)
    
    // 1. Get the external resource
    externalResource, err := e.client.GetResource(ctx, cr)
    if err != nil {
        if IsNotFound(err) {
            // Resource does not exist - can be imported
            return managed.ExternalObservation{
                ResourceExists: false,
            }, nil
        }
        return managed.ExternalObservation{}, errors.Wrap(err, "cannot get resource")
    }
    
    // 2. Update status with observed data
    cr.Status.AtProvider = YourResourceObservation{
        // Populate observed fields from externalResource
    }
    
    // 3. Determine if resource is up-to-date (drift detection)
    upToDate := yourResourceUpToDate(&cr.Spec.ForProvider, externalResource)
    
    return managed.ExternalObservation{
        ResourceExists:    true,
        ResourceUpToDate:   upToDate,
    }, nil
}
```

## Drift Detection Implementation

### Pattern 1: upToDate Helper Function

Create a helper function that compares desired spec fields against actual external resource state:

```go
func yourResourceUpToDate(desired *YourResourceParameters, actual *ExternalResource) bool {
    // Compare each spec field against actual state
    if desired.Field != actual.Field {
        return false
    }
    if desired.AnotherField != actual.AnotherField {
        return false
    }
    // ... compare all relevant fields
    return true
}
```

### Pattern 2: Direct Comparison in Observe

For simple cases, comparison can be done inline:

```go
func (e *external) Observe(ctx context.Context, mg resource.Managed) (managed.ExternalObservation, error) {
    // ... fetch resource ...
    
    upToDate := cr.Spec.ForProvider.Name == resource.Name &&
                cr.Spec.ForProvider.Region == resource.Region
    
    return managed.ExternalObservation{
        ResourceExists:  true,
        ResourceUpToDate: upToDate,
    }, nil
}
```

## Importing Existing Resources

The pattern enables importing existing resources through the following flow:

1. **User creates a managed resource** with `externalName` set to the existing resource's identifier
2. **Observe is called** - finds the resource (ResourceExists: true)
3. **Crossplane compares state** - since ResourceUpToDate is true, no update is triggered
4. **Resource is imported** - status is populated with observed data

### Using externalName

The `externalName` annotation (or `.metadata.name`) is used to identify the external resource:

```go
func (e *external) Observe(ctx context.Context, mg resource.Managed) (managed.ExternalObservation, error) {
    cr := mg.(*YourResourceType)
    
    // Use externalName to look up the resource
    externalName := meta.GetExternalName(cr)
    if externalName == "" {
        return managed.ExternalObservation{
            ResourceExists: false,
        }, nil
    }
    
    // Query external API using externalName
    resource, err := e.client.GetResource(ctx, externalName)
    // ...
}
```

## Compliance Requirements

All controllers must implement:

| Requirement | Description | Implementation |
|-------------|-------------|----------------|
| Observe method | Implement `Observe()` on external client | Returns ExternalObservation |
| ResourceExists | Set to true/false based on API lookup | `ResourceExists: true/false` |
| ResourceUpToDate | Compare spec vs actual state | `ResourceUpToDate: true/false` |

### Recommended

| Recommendation | Description | Implementation |
|----------------|-------------|----------------|
| upToDate helper | Separate comparison function | Improves testability |
| NotFound handling | Handle 404 from external API | Returns ResourceExists: false |

## Running Compliance Check

Use the provided script to verify compliance:

```bash
# Check all providers
./scripts/check_introspection_compliance.sh

# Check specific provider
./scripts/check_introspection_compliance.sh provider-gitea

# Verbose output
./scripts/check_introspection_compliance.sh --verbose provider-gitea
```

## Provider Architecture Patterns

### Modern Pattern (Recommended)

Uses `managed.NewReconciler` with `managed.WithExternalConnector`:

```go
func Setup(mgr ctrl.Manager, o controller.Options) error {
    return ctrl.NewControllerManagedBy(mgr).
        For(&YourResource{}).
        Complete(managed.NewReconciler(mgr,
            resource.ManagedKind(YourResourceGroupVersionKind),
            managed.WithExternalConnector(&connector{kube: mgr.GetClient()}),
            // ...
        ))
}
```

### Legacy Pattern (Deprecated)

Uses custom reconciler without ExternalClient interface:

```go
func (r *YourReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    // Manual implementation
    // Does NOT support standard Observe pattern
}
```

**Note**: The legacy pattern does not support the standard introspection/drift detection mechanism. New providers should use the modern pattern.

## Example: provider-gitea Repository Controller

See `provider-gitea/internal/controller/repository/repository.go` for a complete example:

- Observe method with external API lookup
- upToDate helper function for drift detection
- Status population with observed data

## References

- [Crossplane Runtime: External Client](https://pkg.go.dev/github.com/crossplane/crossplane-runtime@v2.0.0/pkg/reconciler/managed#ExternalClient)
- [Import Existing Resources](https://docs.crossplane.io/latest/concepts/managed-resources/#importing-existing-resources)
- [Provider Development Guide](https://docs.crossplane.io/latest/concepts/providers/)