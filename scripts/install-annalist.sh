# Not currently live
cd .annalist

sudo docker pull gklyne/annalist_site
sudo docker pull gklyne/annalist

# one time
sudo docker run --name=annalist_site --detach gklyne/annalist_site
#sudo docker run --interactive --tty --rm \
#    --publish=8000:8000 --volumes-from=annalist_site \
#    gklyne/annalist bash <<!
sudo docker run --interactive --tty --rm \
    --network=internal --name=annalist --volumes-from=annalist_site \
    gklyne/annalist bash
# one time
annalist-manager createsitedata
annalist-manager initialize
# or later
annalist-manager updatesitedata

annalist-manager runserver
!
sudo docker run \
--network=internal --name=annalist --volumes-from=annalist_site \
-d --restart=always gklyne/annalist annalist-manager runserver

