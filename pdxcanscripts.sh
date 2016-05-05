#Print the first column and the last which has coma-delimited columns in itself
awk -F "\t"  '$3 == "gene" { print $1, $9 }' transcriptome.gtf | awk -F "; " '{ print $1, $5 }' > test.txt
#Print the coma-delimited that has gene information.  Print gene name
awk '{print substr($1,4), $3, $5 }' test.txt > ChrENGene.txt
#use R to name column
col.names(ChrENGene) <- c('CHR','gene','gene_name')
#Make sure Chr is numeric
ChrENGene <- transform(ChrENGene, CHR= as.numeric(CHR))
#Join with tissue of choice
Tissue <- left_join(association.txt,CHrENGene, by = 'gene')
#make a qq plot
qq(tissue$p, main= 'Q-Q Plot of Tissue', pch=18)
#make a manhattan plot without position.  p-value threshold for label, and color can be adjusted
ggplot(Tissue, aes(x=CHR, y=-log10(p), color=CHR)) +  geom_point(aes(size = 10,)) + geom_text(aes(label=ifelse(-log10(p)>4.7,as.character(gene_name),'')),hjust= 1.2, vjust=0) + ggtitle("Manhattan Plot Tissue") + xlab("Chromosome") + ylab("-log10(p)") + theme_set(theme_gray(base_size = 18))+ theme(legend.position="none") + scale_x_continuous(breaks=seq(1,25,1))

