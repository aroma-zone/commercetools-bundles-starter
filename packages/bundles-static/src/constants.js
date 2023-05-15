import { entryPointUriPathToPermissionKeys } from '@commercetools-frontend/application-shell/ssr';

const ROOT_PATH = 'bundles';
const BUNDLE_PRODUCT_TYPE = 'static-bundle-parent';
const MASTER_VARIANT_ID = 1;
const entryPointUriPath = 'bundles';

const PERMISSIONS = entryPointUriPathToPermissionKeys(entryPointUriPath);

export {
  ROOT_PATH,
  BUNDLE_PRODUCT_TYPE,
  MASTER_VARIANT_ID,
  entryPointUriPath,
  PERMISSIONS,
};
