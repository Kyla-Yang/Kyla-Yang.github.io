#读取文件有问题，最后发现是header有问题，重新跑比对
$samtools quickcheck M1 sorted.bam
#MI sorted.bam had no targets in header

#抽取小部分reads进行运行和检验
seqtk sample -s 123 F1_1.fastq.gz 100 > r1_sample.fastq
seqtk sample -s 123 F1_2.fastq.gz 100 > r2_sample.fastq
r1_sample=r1_sample.fastq
r2_sample=r2_sample.fastq
bwa mem $genome $r1_sample.fastq $r2_sample.fastq > /public2/home/rotation/yyn/He_reseq/Here.Female/sample.sam
samtools view -S -b sample.sam > sample.bam
samtools sort sample.bam -o sample_sorted.bam
samtools index sample_sorted.bam
rm sample.sam
