#found genome index
genome="genome/fasta"
bwa index genome

#activate the independent environment for bwa
conda activate bwa_env

genome="He_genome.fasta"
bwa index $genome

r1_files=(*_1.fastq.gz)
for r1_file in ${r1_files[@]}; do
  sample_name=$(basename $r1_file _1.fastq.gz)
  r2_file=${sample_name}_2.fastq.gz
  echo "Processing R1 file: $r1_file" #debugging information
  echo "Processing R2 file: $r2_file"
  gzip -d $r1_file
  gzip -d $r2_file
  bwa mem /public2/home/rotation/He_reseq/He_genome.fasta ${sample_name}_1.fastq.gz ${sample_name}_2.fastq.gz > ${sample_name}.sam
  samtools view -S -b ${sample_name}.sam > ${sample_name}.bam
  echo "Processing BAM file: ${sample_name}.bam"
  samtools sort ${sample_name}.bam -o ${sample_name}_sorted.bam
  samtools index ${sample_name}_sorted.bam
  rm ${sample_name}_1.fastq
  rm ${sample_name}_2.fastq
  rm ${sample_name}.sam
done

conda deactivate
