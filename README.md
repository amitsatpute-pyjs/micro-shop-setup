# Micro-shop-setup

Please follow following steps:

1. Run **"sh setRegCluster.sh"**
    -  it will be create cluster and registry on local system.
2. Run **"sh deployAllRepo.sh"**
    -  it will pull repos from github and duid socker images and push those images in k3d registary
        
        *(Note: you can change branch name, This need to be modified )*

3. Run **"sh runServices.sh"** :
    - it will deploy all services    


------------------------------------


No need to use, it is handled.

*Error: ER_NOT_SUPPORTED_AUTH_MODE: Client does not support *authentication*protocol requested by server; consider upgrading MySQL client*

Solution: ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

          flush privileges;