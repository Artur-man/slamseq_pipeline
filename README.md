# Slam-seq Pipeline

**SLAM-seq** ([**Herzog et. al 2017**](https://www.nature.com/articles/nmeth.4435)) allows the measurement of gene expression dynamics in the context of total RNA by incorporating 4-thiouridine (4sU) in newly synthesized RNA molecules. 
Those incorporated 4sU molecules are then converted to Cs giving single nucleotide resolution.

The SLAM-seq pipeline includes Quality Control, rRNA filtering using Bowtie2, Bowtie and STAR prior to Hisat3N alignment for accounting U>C substitutions. The converted and uncorverted reads are generated with a custom Java code, and then gene and isoform expression levels are estimated by RSEM or Kallisto. 

##### Steps:
  1. For Quality Control, we use FastQC to create qc outputs. There are optional read quality filtering (trimmomatic), read quality trimming (trimmomatic), adapter removal (cutadapt) processes available.
  2. [**Hisat3N**](http://daehwankimlab.github.io/hisat2/hisat-3n/) accounts for U>C substitutions, which is normally recognized as a mismatch when aligning reads to the genome, and does not penalize when detecting a U>C mismatch on the reads.
  3. A custom java code is used for generating converted and uncoverted reads where converted reads are of same sets of reads from unconverted reads with U>C substitutions. 
  3. RSEM is used to align converted and unconverted reads to a reference transcripts and estimates gene and isoform expression levels. RSEM incorporates STAR as the main aligner. 
  4. Alternatively, Kallisto used for quantifying abundances of transcripts based on pseudoalignments.
  5. Genome-wide Bam analysis is done by RseQC, Picard.
  6. Optionally you can create Integrative Genomics Viewer (IGV)  and Genome Browser Files (TDF and Bigwig, respectively)

##### Pipeline Container:
  * Docker: dolphinnext/slamseq_pipeline:1.0
  * GitHub: dolphinnext/slamseq_pipeline

##### Program Versions:
  - FastQC v0.11.8
  - Star v2.6.1
  - Hisat2 v2.1.0
  - Hisat3N 
  - OpenJDK v16.0.2
  - Picard v2.18.27
  - Rseqc v2.6.2
  - Samtools v1.3
  - Subread v1.6.4
  - Multiqc v1.7
  - Tophat v2.1.1
  - RSEM v1.3.1
  - Bowtie2 v2.3.5
  - Bowtie v1.2.2
  - Trimmomatic v0.39
  - Igvtools v2.5.3
  - Bedtools v2.27.1
  - Fastx_toolkit v0.0.14
  - Ucsc-wigToBigWig v366
  - Kallisto v0.46.0
