# mobile_arquitetura_02 — Questionário de Reflexão

## 1. Em qual camada foi implementado o mecanismo de cache? Explique por que essa decisão é adequada.

O cache foi implementado na camada **data**, no arquivo `data/datasources/productcachedatasource.dart` (`ProductCacheDatasource`). O uso do cache é coordenado pelo `ProductRepositoryImpl`, também na camada `data`:

```dart

final cached = cache.get();
if (cached != null) {
  return cached.map((m) => Product(...)).toList();
}
throw Failure("Não foi possível carregar os produtos");
```

**Por que é adequado:** o cache é uma responsabilidade de acesso a dados — ele decide de onde os dados vêm. Não é uma regra de negócio nem uma decisão de interface. Mantê-lo na camada `data` permite que as camadas `domain` e `presentation` permaneçam completamente ignorantes de sua existência. Além disso, se o cache precisasse ser trocado por uma solução persistente (`shared_preferences`, `Hive`), apenas `ProductCacheDatasource` precisaria ser alterado.

---

## 2. Por que o ViewModel não deve realizar chamadas HTTP diretamente?

O `ProductViewModel` recebe apenas um `ProductRepository` (contrato abstrato) e nunca importa `Dio` nem conhece URLs:

```dart
class ProductViewModel {
  final ProductRepository repository; // depende da abstração, não da implementação
  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(products: products, isLoading: false);
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

Realizar HTTP diretamente no ViewModel violaria a arquitetura por quatro razões:

- **Separação de responsabilidades:** o ViewModel gerencia estado (loading, erro, dados); o DataSource executa I/O. Misturar os dois torna cada classe difícil de entender e modificar.
- **Testabilidade:** dependendo do contrato `ProductRepository`, o ViewModel pode ser testado com um mock sem precisar de rede real.
- **Troca transparente de fonte:** o repositório pode ser substituído por um banco local sem alterar nenhuma linha do ViewModel.
- **Regra arquitetural:** camadas superiores (presentation) só conversam com camadas imediatamente abaixo (domain), nunca pulando para data.

---

## 3. O que poderia acontecer se a interface acessasse diretamente o DataSource?

Se a `ProductPage` chamasse o `ProductRemoteDatasource` diretamente, bypassando ViewModel e Repository:

- **Violação de separação de responsabilidades:** a UI passaria a conhecer Dio, URLs e formato de resposta da API — responsabilidades que não são dela.
- **Cache inacessível:** a lógica de fallback para `ProductCacheDatasource` está no Repository. Sem ele, o cache nunca seria consultado em caso de falha.
- **Ausência de tratamento de erros padronizado:** exceções de rede chegariam cruas à interface, sem passar pelo `Failure` da camada `core`.
- **Sem gerenciamento de estado:** os estados `isLoading` e `error` são controlados pelo `ProductViewModel`. Bypassá-lo exigiria duplicar toda essa lógica dentro do widget.
- **Impossibilidade de teste:** um widget que depende diretamente de Dio não pode ser testado sem rede real.

Em resumo: a interface ficaria responsável por rede, cache, tratamento de erros e estado simultaneamente — contrariando todos os princípios da arquitetura em camadas.

---

## 4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?

A troca é possível sem tocar em nenhuma camada acima de `data`, graças ao contrato definido em `domain`:

```dart
// domain/repositories/product_repository.dart
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
```

O processo de substituição seria:

1. Criar `ProductLocalDatasource` que lê de SQLite ou Hive.
2. Criar (ou adaptar) um `ProductRepositoryImpl` que usa o novo DataSource.
3. Registrar a nova implementação em `main.dart` (injeção de dependência já feita manualmente no projeto).

**O que não precisa ser alterado:** `ProductViewModel`, `ProductPage`, `ProductState`, a entidade `Product` e `Failure`. Todas essas classes dependem apenas da abstração `ProductRepository`, não da implementação concreta.

Isso demonstra na prática o **Princípio da Inversão de Dependência (DIP):** módulos de alto nível (presentation, domain) não dependem de módulos de baixo nível (data). Ambos dependem de abstrações.