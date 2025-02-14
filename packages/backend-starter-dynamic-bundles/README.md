# Dynamic Bundles Backend

## Configuration

To configure the commercetools project, add the corresponding values and run the `configure-environment.sh` script.

```bash
$> bash configure-environment.sh
```

Be aware that we need the `manage_api_clients` scope to create the API client for the extension.

## Deployment

Dynamic Bundles requires building a custom frontend shop UI to handle the selection of products from the categories selected by the customer of the shop. The dynamic bundles checkout flow can then proceed through adding line items to the cart from the items selected by the customer. A custom backend should also be built based on customer requirements.  The custom built backend solution for dynamic bundles is not included in this repo and should be developed for the custom solution. See https://github.com/commercetools/commercetools-bundles-starter/tree/master/packages/bundles-dynamic#development and the information under docs/dynamic/index.md heading "Complete the Solution: Your Implementation Responsibilities" https://github.com/commercetools/commercetools-bundles-starter/blob/master/docs/dynamic/index.md.

An extension can be developed if the customer requires an extension in their custom backend flow.  The code in the 'platform-extension-static-bundles' package demonstrates an extension for bundles to add line items to the cart, but the extension may not be required for dynamic in the same format. The static starter sample extension provides sample API-level support for checking bundle product types and should be extended for a backend dynamic solution.  It is meant to be a starter for cart flows and should require further implementation for custom dynamic bundle cart flow.  The dynamic bundles solution requires a custom UI and cart flow backend for addition of the user chosen line items to the cart.  Note that an extension may not be needed in a custom cart flow for Dynamic bundles.  The static extension package can be extended and integrated into an extension based solution for carts by checking types to add/modify line items. If an extension is not used, line items can be added to the cart from the UI or a service layer.

This folder includes definitions for dynamic bundles types and product types using the commercetools Terraform provider. 
