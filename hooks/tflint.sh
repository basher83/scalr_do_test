#Install TFLint to /tmp
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | TFLINT_INSTALL_PATH=/tmp bash

#Call TFLint
/tmp/tflint