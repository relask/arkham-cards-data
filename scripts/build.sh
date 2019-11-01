#!/bin/bash

set -e

rm -rf build
mkdir build
mkdir build/campaigns
cd campaigns
for f in *; do
    if [ -d ${f} ]; then
        echo '{' > ../build/campaigns/$f.json
        echo '  "campaign":' >> ../build/campaigns/$f.json
        cat $f/campaign.json >> ../build/campaigns/$f.json
        echo ', "scenarios": [' >> ../build/campaigns/$f.json
        count=0
        for s in ${f}/*.json; do
          if [[ $s = *campaign.json ]]
          then
            echo "Outputing $f"
          else
            if [ $count -ne 0 ]
            then
              echo ',' >> ../build/campaigns/$f.json
            fi
            cat $s >> ../build/campaigns/$f.json
            count=1
          fi
        done
        echo ']}' >> ../build/campaigns/$f.json
    fi
done

cd ../build
count=0
echo '[' > ./allCampaigns.json
for f in campaigns/*; do
    if [ $count -ne 0 ]
    then
        echo ',' >> ./allCampaigns.json
    fi
    cat $f >> ./allCampaigns.json
    count=1
done
echo ']' >> ./allCampaigns.json
cd ..
cp build/allCampaigns.json demo/src/assets/allCampaigns.json
