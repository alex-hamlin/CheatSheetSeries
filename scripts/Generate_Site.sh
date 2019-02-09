#!/bin/bash
# Dependencies:
#  sudo apt install -y nodejs
#  sudo npm install gitbook-cli -g
# Note:
#   PDF generation is not possible because the content is cutted in 
#   some CS like for example the abuse case one
GENERATED_SITE=site
WORK=../generated
echo "Generate a offline portable website with all the cheat sheets..."
echo "Step 1/5: Init work folder."
rm -rf $WORK 1>/dev/null 2>&1
mkdir $WORK
mkdir $WORK/cheatsheets
echo "Step 2/5: Generate the summary markdown page."
python Update_CheatSheets_Index.py
python Generate_CheatSheets_TOC.py
echo "Step 3/5: Create the expected GitBook folder structure."
cp ../book.json $WORK/.
cp ../Preface.md $WORK/cheatsheets/.
mv TOC.md $WORK/cheatsheets/.
cp -r ../cheatsheets $WORK/cheatsheets/cheatsheets
cp -r ../assets $WORK/cheatsheets/assets
cp ../Index.md $WORK/cheatsheets/cheatsheets/Index.md
sed -i 's/assets\//..\/assets\//g' $WORK/cheatsheets/cheatsheets/Index.md
sed -i 's/cheatsheets\///g' $WORK/cheatsheets/cheatsheets/Index.md
echo "Step 4/5: Generate the site."
cd $WORK
gitbook install --log=error
gitbook build . $WORK/$GENERATED_SITE --log=info
echo "Step 5/5: Cleanup."
rm -rf cheatsheets
rm -rf node_modules
rm book.json
echo "Generation finished to the folder: $WORK/$GENERATED_SITE"