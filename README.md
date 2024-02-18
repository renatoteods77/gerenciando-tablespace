# gerenciando-tablespace
Gerenciando Tablespaces
Tablespaces
➢
Tablespaces são containers lógicos para segmentos do banco de dados;
➢
Segmentos são objetos do banco de dados que ocupam espaço, como tabelas e índices;
➢
No nível físico, os dados da tablespace são armazenados em data files ou temp files;
➢
Um banco de dados Oracle deve possuir pelo menos as tablespace SYSTEM e SYSAUX;
Existem dois tipos de tablespaces:
▪
Permanentes: agrupa objetos de schema persistentes. Os dados desse tipo de tablespace são armazenados em data files no nível físico;
▪
Temporárias: contém dados transitórios, que existem apenas durante a duração de uma sessão. Dados de objetos permanentes de schema não residem em tablespaces temporárias. Os dados desse tipo de tablespace são armazenados em temp files no nível físico;
Gerenciando Tablespaces
➢
As tablespaces também podem ser categorizadas em relação aos seus data files ou temp files:
▪
Smallfile: são tablespaces que podem ter mais de um data file associado, porém estes data files possuem tamanhos menores. Por exemplo, uma smallfile tablespace com blocos 8k pode ter um data file de 32GB;
▪
Bigfile: são tablespaces que possuem um único data file, mas que pode ter um tamanho grande. Por exemplo, uma bigfile tablespace com blocos 8k pode ter um data file de 32TB;
➢
Bigfile tablespaces facilitam a administração do banco, porém precisam de acompanhamento constante em relação ao espaço ocupado;

![image](https://github.com/renatoteods77/gerenciando-tablespace/assets/34043344/86e8082b-bd3a-4994-9ce6-6f92a00df315)
