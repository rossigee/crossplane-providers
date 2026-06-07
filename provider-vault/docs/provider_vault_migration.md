# provider-vault Migration to Modern Crossplane Patterns

## Current State

provider-vault uses legacy Crossplane patterns that don't support:
- Import existing resources (introspection)
- Drift detection
- Standard ExternalClient interface

## Required Changes

### 1. API Types (`apis/v1alpha1/types.go`)

Each managed resource type needs to embed Crossplane v2 types:

```go
// BEFORE (legacy)
type MountSpec struct {
    ProviderConfigReference *ProviderConfigReference `json:"providerConfigRef,omitempty"`
    ForProvider            MountParameters         `json:"forProvider"`
}

type MountStatus struct {
    Conditions []metav1.Condition `json:"conditions,omitempty"`
}

// AFTER (modern)
import xpv1 "github.com/crossplane/crossplane/apis/v2/core/v2"

type MountSpec struct {
    xpv1.ManagedResourceSpec `json:",inline"`
    ForProvider              MountParameters `json:"forProvider"`
}

type MountStatus struct {
    xpv1.ManagedResourceStatus `json:",inline"`
    AtProvider                 MountObservation `json:"atProvider,omitempty"`
}

type MountObservation struct {
    UUID string `json:"uuid,omitempty"`
}
```

### 2. Dependencies

Need to add crossplane v2 APIs:
```
github.com/crossplane/crossplane/apis/v2 v2.3.1
```

### 3. Controllers

Each controller needs refactoring from legacy reconciler:

```go
// BEFORE (legacy)
type MountReconciler struct {
    client client.Client
    scheme *runtime.Scheme
    log    logr.Logger
}

func (r *MountReconciler) Reconcile(ctx context.Context, req ctrl.Request) error {
    // Manual implementation
}

// AFTER (modern)
func SetupMountController(mgr ctrl.Manager, o xpcontroller.Options) error {
    r := managed.NewReconciler(mgr,
        resource.ManagedKind(v1alpha1.MountGroupVersionKind),
        managed.WithExternalConnector(&connector{kube: mgr.GetClient()}),
        ...
    )
    ...
}

type external struct{ client *api.Client }

func (e *external) Observe(ctx context.Context, mg resource.Managed) (managed.ExternalObservation, error) {
    // Returns ResourceExists and ResourceUpToDate for drift detection
}
```

### 4. Files to Update

- `apis/v1alpha1/types.go` - All 12 resource types
- `internal/controller/vault/mount.go`
- `internal/controller/vault/policy.go`
- `internal/controller/vault/pkirole.go`
- `internal/controller/vault/kvsecret.go`
- `internal/controller/vault/authbackend.go`
- `internal/controller/vault/authbackendrole.go`
- `internal/controller/vault/transitkey.go`
- `internal/controller/vault/databaserole.go`
- `internal/controller/vault/identitygroup.go`
- `internal/controller/vault/secretbackend.go`
- `internal/controller/vault/secretbackendrole.go`

### 5. Generate Code

After API changes:
```bash
make generate
```

## Compliance Check

After migration, run:
```bash
./scripts/check_introspection_compliance.sh provider-vault
```

Expected result: 11 passed (one for each controller)

## Complexity Notes

- Legacy controllers use custom `SetConditions` with string args
- New pattern uses `xpv1.Condition` types
- ProviderConfigReference types differ between v1alpha1 and xpv1
- Need to ensure deepcopy methods implement resource.Managed interface

## Alternative: Keep Legacy Pattern

If migration is too complex, document that provider-vault uses legacy patterns and:
1. Update CLAUDE.md to note this
2. Exclude from compliance checks
3. Consider deprecation in favor of upstream provider-vault