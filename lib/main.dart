import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5EFE6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B7355),
          primary: const Color(0xFF8B7355),
          secondary: const Color(0xFFB8A88A),
          surface: const Color(0xFFF5EFE6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B7355),
          foregroundColor: Color(0xFFFDFBF7),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFFDFBF7),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFDFBF7),
          elevation: 2,
          shadowColor: const Color(0xFF8B7355).withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8B7355),
          foregroundColor: Color(0xFFFDFBF7),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B7355),
            foregroundColor: const Color(0xFFFDFBF7),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFDFBF7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD9CFC0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD9CFC0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF8B7355), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF8B7355)),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF5C4A38),
          contentTextStyle: TextStyle(color: Color(0xFFFDFBF7)),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const TelaLista(),
    );
  }
}

class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  final List<Item> _itens = [];

  Future<void> abrirTelaAdicionar() async {
    final Item? novoItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(builder: (context) => const TelaAdicionarItem()),
    );

    if (novoItem != null) {
      setState(() {
        _itens.add(novoItem);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${novoItem.nome} adicionado à lista'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void removerItem(int indice) {
    final String nomeRemovido = _itens[indice].nome;

    setState(() {
      _itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nomeRemovido removido da lista'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int comprados = _itens.where((item) => item.comprado).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$comprados de ${_itens.length} comprados',
              style: const TextStyle(
                color: Color(0xFFFDFBF7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ),
      body: _itens.isEmpty
          ? const Center(
              child: Text(
                'Nenhum item na lista.\nToque no + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9C8B75),
                  height: 1.6,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _itens.length,
              itemBuilder: (context, indice) {
                final Item item = _itens[indice];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    leading: Checkbox(
                      value: item.comprado,
                      activeColor: const Color(0xFF4CAF50),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFB8A88A),
                        width: 1.8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (valor) {
                        setState(() {
                          item.comprado = valor ?? false;
                        });
                      },
                    ),
                    title: Text(
                      item.nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: item.comprado
                            ? const Color(0xFFB0A28F)
                            : const Color(0xFF3E3226),
                        decoration: item.comprado
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: const Color(0xFFB0A28F),
                      ),
                    ),
                    subtitle: Text(
                      'Quantidade: ${item.quantidade}',
                      style: const TextStyle(
                        color: Color(0xFF8B7355),
                        fontSize: 13,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFB5654A),
                      ),
                      tooltip: 'Remover item',
                      onPressed: () => removerItem(indice),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirTelaAdicionar,
        tooltip: 'Adicionar item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void salvar() {
    final String nome = _nomeController.text.trim();
    final String quantidadeTexto = _quantidadeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe o nome do item.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final int quantidade = int.tryParse(quantidadeTexto) ?? 1;

    final Item novoItem = Item(
      nome: nome,
      quantidade: quantidade,
    );

    Navigator.pop(context, novoItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nome do item',
                hintText: 'Ex: Arroz, Feijão, Leite...',
                prefixIcon: Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF8B7355),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                hintText: 'Ex: 2',
                prefixIcon: Icon(
                  Icons.numbers,
                  color: Color(0xFF8B7355),
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: salvar,
              icon: const Icon(Icons.save_outlined),
              label: const Text(
                'Salvar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}