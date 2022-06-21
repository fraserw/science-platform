cd

conda activate dragons3

# retrieve the gemini gmos test data
wget http://www.gemini.edu/sciops/data/software/datapkgs/gmosimg_tutorial_datapkg-v1.tar
tar -xvf gmosimg_tutorial_datapkg-v1.tar
bunzip2 gmosimg_tutorial/playdata/*.bz2

# create the gemini calibration manager
mkdir .geminidr
echo [calibs] > .geminidr/rsys.cfg
echo standalone = True >> .geminidr/rsys.cfg
echo database_dir = /arc/home/testuser/gmosimg_tutorial/playground  >> .geminidr/rsys.cfg
caldb init

# create the image lists
cd gmosimg_tutorial/playground/
dataselect --tags BIAS ../playdata/*.fits -o list_of_bias.txt
dataselect --tags FLAT ../playdata/*.fits -o list_of_flats.txt
dataselect --xtags CAL ../playdata/*.fits -o list_of_science.txt

# now reduce some data
reduce @list_of_bias.txt
caldb add N20170613S0180_bias.fits
reduce @list_of_flats.txt
caldb add N20170702S0178_flat.fits
reduce @list_of_science.txt

### old lsst stuff to delete
#mkdir test
#cd test
#git lfs install
#git clone https://github.com/lsst/testdata_ci_hsc.git
#cd testdata_ci_hsc
#setup -j -r .
#cd ../
#git clone https://github.com/lsst/ci_hsc_gen2.git
#cd ci_hsc_gen2
#setup -j -r .
#./bin/linker.sh
#cd ../
#mkdir DATA
#echo "lsst.obs.hsc.HscMapper" > DATA/_mapper
#ingestImages.py DATA $CI_HSC_GEN2_DIR/raw/*.fits --mode=link
