# Can’t Load Gem from /vendor Error

If you get an error that some gem can’t be loaded, like `bcrypt_ext`, follow these steps to rebuild this repo’s dev setup. From the root directory of this repo:

```sh
rm -rf vendor/gems
rm -rf .bundle
./script/setup
```
