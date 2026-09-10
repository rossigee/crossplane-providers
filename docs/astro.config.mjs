import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  integrations: [
    starlight({
      title: 'Crossplane Providers',
      description: 'Lean, focused Crossplane providers designed for efficiency and operational simplicity.',
      social: {
        github: 'https://github.com/rossigee/crossplane-providers',
      },
      sidebar: [
        { label: 'Overview', link: '/' },
        {
          label: 'Standards',
          autogenerate: { directory: 'standards' },
        },
        { label: 'Troubleshooting', link: '/troubleshooting' },
        { label: 'Maintenance History', link: '/maintenance-history' },
      ],
    }),
  ],
});
