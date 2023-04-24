conda activate gatk_env

for f in /public2/home/rotation/yyn/He_reseq/sorted_bam/Here.male *_sorted.bam
do
   echo "Processing $f file..."
   prefix=$(basename $f _sorted.bam)
   sorted_rmdup_bam=${prefix}_sorted_rmdup.bam
   gatk HaplotypeCaller -R /public2/home/rotation/yyn/He_genome.fasta -I $f -ERC GVCF --emit-ref-confidence GVCF -O ${prefix}_g.vcf.gz
   gatk CombineGVCFs --reference /public2/home/rotation/yyn/He_genome.fasta -V ${prefix}_g.vcf.gz -O ${prefix}.g.vcf.gz
   gatk GenotypeGVCFs --reference /public2/home/rotation/yyn/He_genome.fasta -V ${prefix}.g.vcf.gz -O ${prefix}.raw.vcf.gz
   gatk SelectVariants --select-type-to-include SNP --reference /public2/home/rotation/yyn/He_genome.fasta -V ${prefix}.raw.vcf.gz -O ${prefix}.raw.snp.vcf.gz
   gatk VariantFiltration -V ${prefix}.raw.snp.vcf.gz --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "snp_filter" --genotype-filter-expression "DP < 2 || DP > 50" --genotype-filter-name "dp_fail" -O ${prefix}.flag.snp.vcf.gz
   gatk SelectVariants --exclude-filtered true --restrict-alleles-to BIALLELIC --reference /public2/home/rotation/yyn/He_genome.fasta -V ${prefix}.flag.snp.vcf.gz -O ${prefix}.hardfiltered.snp.vcf.gz
   gatk SelectVariants --select-type-to-include INDEL --reference /public2/home/rotation/yyn/He_genome.fasta -V ${prefix}.raw.vcf.gz -O ${prefix}.raw.indel.vcf.gz
   gatk VariantFiltration -V ${prefix}.raw.indel.vcf.gz -O ${prefix}.filtered.indel.vcf.gz --filter-expression "QD < 2.0 ||FS > 200.0 || MQ < 40.0 || SOR > 10.0 || ReadPosRankSum < -8.0"
   gatk SelectVariants --exclude-filtered -V ${prefix}.filtered.indel.vcf.gz -O ${prefix}.filtered.indel.pass.vcf.gz 
done

conda deactivate
