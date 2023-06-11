##GATK HaplotypeCaller ERROR
#A USER ERROR has occurred: Argument emit-ref-confidence has a bad value: Can only be used in single sample mode currently. 
#SOLUTION: using picard to add the reading group into BAM files
#https://www.jianshu.com/p/de1c027e672b

#Here is a for loop going through every raw BAM file in the folder.
for f in /public2/home/rotation/yyn/He_reseq/fbam/*_sorted_rmdup.bam
do
   echo "Processing $f file..."
   prefix=$(basename $f _sorted_rmdup.bam)
   picard AddOrReplaceReadGroups -I ${prefix}_sorted_rmdup.bam -O ${prefix}_sorted_rmdup_addrg.bam --RGID sample1 --RGLB lib1 --RGPL illumina --RGPU unit1 --RGSM sample1 --VALIDATION_STRINGENCY LENIENT -Xms1g -Xmx10g -XX:ParallelGCThreads=10
done
