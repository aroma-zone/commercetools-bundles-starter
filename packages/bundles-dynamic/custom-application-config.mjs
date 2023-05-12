import { entryPointUriPath, PERMISSIONS } from "./src/constants";

const config = {
    name: "bundles",
    entryPointUriPath: entryPointUriPath,
    cloudIdentifier: "gcp-eu",
    env: {
        production: {
            applicationId: "clg4ugg1j00zsyp01tnxdkljw",
            url: "wondrous-cocada-43bdf8.netlify.app",
        },
        development: {
            initialProjectKey: "bundles"
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
