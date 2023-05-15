import { entryPointUriPath, PERMISSIONS } from './src/constants';

const config = {
  name: 'Static bundles',
  entryPointUriPath: entryPointUriPath,
  cloudIdentifier: "gcp-eu",
  env: {
    production: {
      applicationId: "clh95s1bt0088ux017396c5in",
      url: "https://silly-kelpie-df8923.netlify.app",
    },
    development: {
      initialProjectKey: "aromazone-dev"
    },
  },
  oAuthScopes: {
    view: ['view_products'],
    manage: ['manage_products'],
  },
  icon: '${path:@commercetools-frontend/assets/application-icons/rocket.svg}',
  mainMenuLink: {
    defaultLabel: 'Bundles',
    permissions: [PERMISSIONS.View],
    labelAllLocales: [],
  },
};

export default config;
