import { entryPointUriPath, PERMISSIONS } from "./src/constants";

const config = {
    name: "bundles",
    entryPointUriPath: entryPointUriPath,
    cloudIdentifier: "gcp-eu",
    env: {
        production: {
            applicationId: "clh95s1bt0088ux017396c5in",
            url: "https://wondrous-cocada-43bdf8.netlify.app",
        },
        development: {
            initialProjectKey: "aromazone-dev"
        }
    },
    oAuthScopes: {
        view: ["view_products"],
        manage: ["manage_products"]
    },
    icon: '${path:@commercetools-frontend/assets/application-icons/rocket.svg}',
    mainMenuLink: {
        defaultLabel: "Dynamic Bundles",
        permissions: [PERMISSIONS.View],
        labelAllLocales: []
    }
}

export default config
