# Extract Variants

A nextflow pipeline to extract SNPs, regions from imputed genotypes.

## Quick Start

1) Install [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html#installation) (>=21.04.0)

2) Run the pipeline on a test dataset

```
nextflow run main.nf -profile test,development
```

## Parameters

### Required parameters


| Option        | Value          | Description  |
| ------------- |-----------------| -------------|
| `project`     | my-project-name | Name of the project |
| `genotypes_array`     |  /path/to/allChrs.{bim,bed,fam} | Path to the array genotypes (single merged file in plink format).  |
| `genotypes_imputed`     |  /path/to/vcf/\*vcf.gz or /path/to/bgen/\*bgen | Path to imputed genotypes in VCF or BGEN format) |
| `genotypes_imputed_format `     | vcf *or* bgen | Input file format of imputed genotypes   |
| `genotypes_build`     | hg19 *or* hg38 | Imputed genotypes build format |
| `queries`     | /path/to/query-file.txt | File with queries (line by line) |

## Development

```
docker build -t lukfor/extract-variants:latest . # don't ignore the dot
nextflow run main.nf -profile test,development
```

## License
extract-variants is MIT Licensed.

## Contact
If you have any questions about this pipeline please contact
* [Lukas Forer](mailto:lukas.forer@i-med.ac.at)
