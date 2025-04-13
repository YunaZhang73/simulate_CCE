#!/bin/bash

for Vs in 1 10 100; do
  for sdMutation in 0.05 0.1 0.5; do
    for replicate in {1..100}; do

      filepath="Vs${Vs}sd${sdMutation}/burn_in/"

      # total mutations
      awk -F ' ' -v replicate="${replicate}" 'NF >= 6 {
        mutaNum[$2]++;
        effectSum[$2] += $6;
        frequencySum[$2] += $5;
      } END {
        for (generation in mutaNum) {
          if (mutaNum[generation] > 0) {
            print 0, replicate, generation, mutaNum[generation],
            effectSum[generation] / mutaNum[generation],
            frequencySum[generation] / mutaNum[generation];
          } else {
            print 0, replicate, generation, 0, 0, 0;
          }
        }
      }' "${filepath}muta_${replicate}.txt" >> "${filepath}muta2.txt"

      # positive mutations
      awk -F ' ' -v replicate="${replicate}" 'NF >= 6 {
        if ($6 > 0) {
          posNum[$2]++;
          posEffectSum[$2] += $6;
          posFrequencySum[$2] += $5;
        }
      } END {
        for (generation in posNum) {
          if (posNum[generation] > 0) {
            print 0, replicate, generation, posNum[generation],
            posEffectSum[generation] / posNum[generation],
            posFrequencySum[generation] / posNum[generation];
          } else {
            print 0, replicate, generation, 0, 0, 0;
          }
        }
      }' "${filepath}muta_${replicate}.txt" >> "${filepath}posMuta2.txt"

      # negative mutations
      awk -F ' ' -v replicate="${replicate}" 'NF >= 6 {
        if ($6 < 0) {
          negNum[$2]++;
          negEffectSum[$2] += $6;
          negFrequencySum[$2] += $5;
        }
      } END {
        for (generation in negNum) {
          if (negNum[generation] > 0) {
            print 0, replicate, generation, negNum[generation],
            negEffectSum[generation] / negNum[generation],
            negFrequencySum[generation] / negNum[generation];
          } else {
            print 0, replicate, generation, 0, 0, 0;
          }
        }
      }' "${filepath}muta_${replicate}.txt" >> "${filepath}negMuta2.txt"

    done
  done
done


# For gradual shift

Vs_total=($(cat Vs_total.txt))
sdMutation_total=($(cat sdMutation_total.txt))
speed_total=($(cat speed_total.txt))

for npara in {0..174}; do
  Vs=${Vs_total[$npara]}
  sdMutation=${sdMutation_total[$npara]}
  speed=${speed_total[$npara]}

  for replicate in {1..100}; do
    filepath="Vs${Vs}sd${sdMutation}/gradual/"

    # total mutations
    awk -F ' ' -v speed="$speed" -v replicate="$replicate" '{
        mutaNum[$2]++; effectSum[$2]+=$6; frequencySum[$2]+=$5;
      }
      END {
        for(generation in mutaNum)
          print speed, replicate, generation, mutaNum[generation],
          effectSum[generation]/mutaNum[generation], frequencySum[generation]/mutaNum[generation]
      }' ${filepath}muta_${speed}_${replicate}.txt >> ${filepath}muta2.txt

    # positive mutations
    awk -F ' ' -v speed="$speed" -v replicate="$replicate" '{
        if($6 > 0) { posNum[$2]++; posEffectSum[$2]+=$6; posFrequencySum[$2]+=$5; }
      }
      END {
        for(generation in posNum)
          print speed, replicate, generation, posNum[generation],
          posEffectSum[generation]/posNum[generation], posFrequencySum[generation]/posNum[generation]
      }' ${filepath}muta_${speed}_${replicate}.txt >> ${filepath}posMuta2.txt

    # negative mutations
    awk -F ' ' -v speed="$speed" -v replicate="$replicate" '{
        if($6 < 0) { negNum[$2]++; negEffectSum[$2]+=$6; negFrequencySum[$2]+=$5; }
      }
      END {
        for(generation in negNum)
          print speed, replicate, generation, negNum[generation],
          negEffectSum[generation]/negNum[generation], negFrequencySum[generation]/negNum[generation]
      }' ${filepath}muta_${speed}_${replicate}.txt >> ${filepath}negMuta2.txt

  done
done
