Atividade 5:

1. Onde ficou o cache e por quê?
Na camada de Dados (Data). Isso isola a regra no Repositório (buscar da API ou do cache), mantendo as camadas de Domínio e Apresentação limpas e sem saber a origem dos dados.

2. Por que o ViewModel não deve fazer chamadas HTTP?
Porque a única responsabilidade dele (na camada de Apresentação) é gerir o estado do ecrã. Fazer requisições acopla a interface à rede e impossibilita testes isolados.

3. O que acontece se a interface aceder diretamente ao DataSource?
Gera forte acoplamento. Qualquer mudança na API obrigaria a reescrever o código das telas (Widgets), misturando regras de negócio com layout visual (o chamado "código esparguete").

4. Como a arquitetura facilita trocar a API por um banco de dados?
Graças à Inversão de Dependência. Basta criar um novo DataSource (ex: SQLite) e injetá-lo no Repositório, sem alterar uma única linha de código nas Telas ou no ViewModel.
