conda activate gatk_env

for f in /public2/home/rotation/yyn/He_reseq/sorted_bam/Here.Female *_sorted.bam
do
   echo "Processing $f file..."
   prefix=$(basename $f _sorted.bam)
   sorted_rmdup_bam=${prefix}_sorted_rmdup.bam
   gatk HaplotypeCaller -R /public2/home/rotation/yyn/He_genome.fasta -I $f --genotyping-mode DISCOVERY -stand-call-conf 20 --emit-ref-confidence GVCF -O ${prefix}.g.vcf.gz
   gatk CombineGVCFs --reference /public2/home/rotation/yyn/He_genome.fasta --variant ${prefix}.g.vcf.gz --output ${prefix}.g.vcf.gz
   gatk GenotypeGVCFs --reference /public2/home/rotation/yyn/He_genome.fasta --variant ${prefix}.g.vcf.gz --output ${prefix}.raw.vcf.gz
   gatk SelectVariants --select-type-to-include SNP --reference /public2/home/rotation/yyn/He_genome.fasta --variant ${prefix}.raw.vcf.gz --output ${prefix}.raw.snp.vcf.gz
   gatk VariantFiltration --variant ${prefix}.raw.snp.vcf.gz --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "snp_filter" --genotype-filter-expression "DP < 2 || DP > 50" --genotype-filter-name "dp_fail" --output ${prefix}.flag.snp.vcf.gz
   gatk SelectVariants --exclude-filtered true --restrict-alleles-to BIALLELIC --reference /public2/home/rotation/yyn/He_genome.fasta --variant ${prefix}.flag.snp.vcf.gz --output ${prefix}.hardfiltered.snp.vcf.gz
   gatk SelectVariants --select-type-to-include SNP --reference /public2/home/rotation/yyn/He_genome.fasta --variant ${prefix}.raw.vcf.gz --output ${prefix}.raw.snp.vcf.gz
   gatk SelectVariants --select-type-to-include INDEL --reference /public2/home/rotation/yyn/He_genome.fasta --variant ${prefix}.raw.vcf.gz --output ${prefix}.raw.indel.vcf.gz
done

conda deactivate
