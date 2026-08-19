import '../models/ingredient.dart';

class IngredientDatabase {
  static final IngredientDatabase _instance = IngredientDatabase._();
  factory IngredientDatabase() => _instance;
  IngredientDatabase._() {
    _buildLookup();
  }

  late final Map<String, Ingredient> _lookup;
  late final List<Ingredient> _substringIngredients;

  static const List<Ingredient> _allIngredients = [
    // ──────────────── MEAT-DERIVED ────────────────
    Ingredient(
      name: 'Gelatin',
      aliases: [
        'gelatin',
        'gelatine',
        'gélatine',
        'gelatina',
        'gel capsule',
        'hydrolyzed gelatin',
        'hydrolysed gelatin'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Protein obtained by boiling animal skin, bones, and connective tissue. Usually from pork or cattle.',
    ),
    Ingredient(
      name: 'Lard',
      aliases: [
        'lard',
        'saindoux',
        'schweineschmalz',
        'schmalz',
        'manteca de cerdo',
        'manteca',
        'strutto',
        'sugna'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Rendered pig fat, commonly used in baked goods and pastries.',
    ),
    Ingredient(
      name: 'Tallow',
      aliases: [
        'tallow',
        'beef tallow',
        'suet',
        'suif',
        'talg',
        'sebo',
        'sego',
        'rindertalg'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Rendered beef or mutton fat used in frying and food processing.',
    ),
    Ingredient(
      name: 'Bone Char',
      aliases: ['bone char', 'bone charcoal', 'animal charcoal', 'char d\'os'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Charred cattle bones, used in sugar refining to whiten sugar.',
    ),
    Ingredient(
      name: 'Bone Meal',
      aliases: [
        'bone meal',
        'edible bone phosphate',
        'bone powder',
        'farine d\'os',
        'knochenmehl'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Ground animal bones used as an anti-caking agent.',
    ),
    Ingredient(
      name: 'Meat Extract',
      aliases: [
        'meat extract',
        'beef extract',
        'meat stock',
        'bone broth',
        'bone stock',
        'beef stock',
        'beef broth',
        'pork stock',
        'pork broth',
        'meat flavoring',
        'meat flavouring',
        'extrait de viande',
        'fleischextrakt',
        'extracto de carne',
        'estratto di carne',
        'bouillon de boeuf'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Concentrated liquid from animal tissue, used in soups, sauces, and bouillon.',
    ),
    Ingredient(
      name: 'Pepsin',
      aliases: ['pepsin', 'pepsine', 'pepsina'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Digestive enzyme from pig stomachs, used in cheese-making.',
    ),
    Ingredient(
      name: 'Collagen',
      aliases: [
        'collagen',
        'collagène',
        'kollagen',
        'colágeno',
        'collagene',
        'elastin',
        'elastine'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Connective tissue protein from animal sources.',
    ),
    Ingredient(
      name: 'Aspic',
      aliases: ['aspic'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Savory gelatin made from meat stock.',
    ),
    Ingredient(
      name: 'Dripping',
      aliases: ['dripping', 'beef dripping', 'meat dripping'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Fat that drips from roasting meat, used as cooking fat.',
    ),
    Ingredient(
      name: 'Castoreum',
      aliases: ['castoreum'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Secretion from beaver glands, sometimes used as "natural flavoring".',
    ),
    Ingredient(
      name: 'Animal Rennet',
      aliases: [
        'rennet',
        'animal rennet',
        'calf rennet',
        'présure',
        'lab',
        'labferment',
        'cuajo',
        'caglio'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Enzyme from calf stomach lining used to make cheese. Microbial/vegetable rennet is the vegetarian alternative.',
    ),
    Ingredient(
      name: 'Pork',
      aliases: [
        'pork',
        'porc',
        'schweinefleisch',
        'schwein',
        'cerdo',
        'puerco',
        'maiale',
        'suino',
        'pork fat',
        'pork gelatin',
        'pork extract'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Meat from pigs.',
    ),
    Ingredient(
      name: 'Beef',
      aliases: [
        'beef',
        'boeuf',
        'bœuf',
        'rindfleisch',
        'rind',
        'res',
        'ternera',
        'manzo',
        'bovino',
        'veal',
        'veau',
        'kalbfleisch',
        'beef fat'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Meat from cattle.',
    ),
    Ingredient(
      name: 'Lamb',
      aliases: [
        'lamb',
        'agneau',
        'lammfleisch',
        'lamm',
        'cordero',
        'agnello',
        'mutton',
        'mouton',
        'hammelfleisch'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Meat from sheep.',
    ),
    Ingredient(
      name: 'Glycine (E640)',
      aliases: ['e640', 'glycine'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation: 'Amino acid often derived from gelatin. May be synthetic.',
    ),
    Ingredient(
      name: 'L-Cysteine (E920)',
      aliases: ['e920', 'l-cysteine', 'l-cysteine hydrochloride', 'cysteine'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Amino acid typically derived from animal hair, feathers, or hooves. Used as a dough conditioner in bread.',
    ),

    // ──────────────── POULTRY-DERIVED ────────────────
    Ingredient(
      name: 'Chicken',
      aliases: [
        'chicken',
        'poulet',
        'huhn',
        'hähnchen',
        'hühnchen',
        'pollo',
        'chicken fat',
        'chicken stock',
        'chicken broth',
        'chicken extract',
        'chicken powder',
        'bouillon de poulet',
        'hühnerbrühe',
        'caldo de pollo',
        'brodo di pollo'
      ],
      category: IngredientCategory.poultry,
      severity: IngredientSeverity.definite,
      explanation: 'Derived from chicken.',
    ),
    Ingredient(
      name: 'Poultry',
      aliases: [
        'poultry',
        'poultry fat',
        'poultry stock',
        'poultry seasoning',
        'volaille',
        'geflügel',
        'ave',
        'pollame'
      ],
      category: IngredientCategory.poultry,
      severity: IngredientSeverity.definite,
      explanation: 'Derived from poultry (chicken, turkey, duck).',
    ),
    Ingredient(
      name: 'Turkey',
      aliases: ['turkey', 'dinde', 'truthahn', 'pavo', 'tacchino'],
      category: IngredientCategory.poultry,
      severity: IngredientSeverity.definite,
      explanation: 'Meat from turkey.',
    ),
    Ingredient(
      name: 'Duck',
      aliases: [
        'duck',
        'canard',
        'ente',
        'pato',
        'anatra',
        'duck fat',
        'graisse de canard'
      ],
      category: IngredientCategory.poultry,
      severity: IngredientSeverity.definite,
      explanation: 'Meat or fat from duck.',
    ),
    Ingredient(
      name: 'Schmaltz',
      aliases: ['schmaltz', 'rendered chicken fat', 'rendered poultry fat'],
      category: IngredientCategory.poultry,
      severity: IngredientSeverity.definite,
      explanation: 'Rendered chicken or goose fat.',
    ),

    // ──────────────── FISH & SEAFOOD-DERIVED ────────────────
    Ingredient(
      name: 'Fish',
      aliases: [
        'fish',
        'poisson',
        'fisch',
        'pescado',
        'pesce',
        'fish oil',
        'fish extract',
        'fish powder',
        'fish stock',
        'fish broth',
        'fumet de poisson',
        'fischbrühe',
        'caldo de pescado',
        'brodo di pesce'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation: 'Derived from fish.',
    ),
    Ingredient(
      name: 'Anchovy',
      aliases: [
        'anchovy',
        'anchovies',
        'anchovy extract',
        'anchovy paste',
        'anchois',
        'sardelle',
        'anchovis',
        'anchoa',
        'boquerón',
        'boqueron',
        'acciuga',
        'alice'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation:
          'Small fish commonly found in Caesar dressing, Worcestershire sauce, and pizza toppings.',
    ),
    Ingredient(
      name: 'Fish Sauce',
      aliases: [
        'fish sauce',
        'sauce de poisson',
        'fischsauce',
        'salsa de pescado',
        'salsa di pesce',
        'nam pla',
        'nuoc mam',
        'patis',
        'aek jeot',
        'colatura di alici',
        'pissalat',
        'garum'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation: 'Fermented fish liquid, staple in Southeast Asian cuisine.',
    ),
    Ingredient(
      name: 'Isinglass',
      aliases: ['isinglass'],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation:
          'Gelatin from fish swim bladders, used to clarify beer and wine.',
    ),
    Ingredient(
      name: 'Omega-3 (Fish)',
      aliases: [
        'fish oil omega',
        'omega-3 fish oil',
        'cod liver oil',
        'fish-derived omega'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation:
          'Omega-3 fatty acids derived from fish oil. Plant-based omega-3 (flaxseed, algae) is vegetarian.',
    ),
    Ingredient(
      name: 'Bonito',
      aliases: [
        'bonito',
        'bonito flakes',
        'katsuobushi',
        'dashi',
        'niboshi',
        'iriko'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation:
          'Dried fermented fish (skipjack tuna), base for Japanese dashi stock.',
    ),
    Ingredient(
      name: 'Oyster Sauce',
      aliases: [
        'oyster sauce',
        'oyster extract',
        'sauce d\'huître',
        'austernsauce',
        'salsa de ostras',
        'salsa di ostriche'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation:
          'Sauce made from oyster extracts, common in Chinese cooking.',
    ),
    Ingredient(
      name: 'Shrimp Paste',
      aliases: [
        'shrimp paste',
        'shrimp',
        'prawn',
        'prawns',
        'crevette',
        'garnele',
        'gamba',
        'gambero',
        'camarón',
        'shrimp powder',
        'shrimp extract'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation:
          'Fermented ground shrimp used in Thai and Southeast Asian curry pastes.',
    ),
    Ingredient(
      name: 'Fish Gelatin',
      aliases: ['fish gelatin', 'fish gelatine'],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation:
          'Gelatin from fish skin and bones. Still non-vegetarian despite being halal/kosher.',
    ),
    Ingredient(
      name: 'Caviar',
      aliases: ['caviar', 'fish roe', 'roe', 'tobiko', 'masago', 'ikura'],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation: 'Fish eggs.',
    ),
    Ingredient(
      name: 'Worcestershire Sauce',
      aliases: ['worcestershire sauce', 'worcestershire', 'worcestersauce'],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation: 'Contains anchovy. Vegetarian versions exist but are rare.',
    ),
    Ingredient(
      name: 'Squid',
      aliases: [
        'squid',
        'squid ink',
        'calamari',
        'calmar',
        'calamar',
        'tintenfisch'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation: 'Derived from squid.',
    ),
    Ingredient(
      name: 'Crab',
      aliases: [
        'crab',
        'crab extract',
        'crabe',
        'krabbe',
        'cangrejo',
        'granchio'
      ],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation: 'Derived from crab.',
    ),
    Ingredient(
      name: 'Lobster',
      aliases: ['lobster', 'homard', 'hummer', 'langosta', 'aragosta'],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.definite,
      explanation: 'Derived from lobster.',
    ),

    // ──────────────── EGG-DERIVED ────────────────
    Ingredient(
      name: 'Egg',
      aliases: [
        'egg',
        'eggs',
        'egg white',
        'egg yolk',
        'whole egg',
        'dried egg',
        'egg powder',
        'egg solids',
        'oeuf',
        'œuf',
        'ei',
        'eier',
        'huevo',
        'huevos',
        'uovo',
        'uova',
        'egg wash',
        'egg glaze'
      ],
      category: IngredientCategory.egg,
      severity: IngredientSeverity.definite,
      explanation:
          'Derived from eggs. Considered non-vegetarian in Indian dietary standards.',
    ),
    Ingredient(
      name: 'Albumin',
      aliases: ['albumin', 'albumen', 'egg albumin', 'egg albumen', 'albumine'],
      category: IngredientCategory.egg,
      severity: IngredientSeverity.definite,
      explanation:
          'Egg white protein used in baked goods and wine clarification.',
    ),
    Ingredient(
      name: 'Lysozyme (E1105)',
      aliases: ['lysozyme', 'e1105', 'lysozym'],
      category: IngredientCategory.egg,
      severity: IngredientSeverity.definite,
      explanation:
          'Enzyme from chicken egg whites, used as a cheese preservative.',
    ),
    Ingredient(
      name: 'Ovalbumin',
      aliases: ['ovalbumin', 'ovomucoid', 'ovomucin', 'ovoglobulin'],
      category: IngredientCategory.egg,
      severity: IngredientSeverity.definite,
      explanation: 'Specific proteins found in egg whites.',
    ),
    Ingredient(
      name: 'Egg Lecithin',
      aliases: ['egg lecithin'],
      category: IngredientCategory.egg,
      severity: IngredientSeverity.definite,
      explanation: 'Lecithin derived from eggs. Soy lecithin is vegetarian.',
    ),
    Ingredient(
      name: 'Meringue',
      aliases: ['meringue', 'meringue powder'],
      category: IngredientCategory.egg,
      severity: IngredientSeverity.definite,
      explanation: 'Made from whipped egg whites.',
    ),
    Ingredient(
      name: 'Mayonnaise',
      aliases: ['mayonnaise', 'mayo'],
      category: IngredientCategory.egg,
      severity: IngredientSeverity.definite,
      explanation:
          'Contains egg yolk. Vegan versions exist but traditional mayo uses eggs.',
    ),

    // ──────────────── INSECT-DERIVED ────────────────
    Ingredient(
      name: 'Carmine (E120)',
      aliases: [
        'carmine',
        'cochineal',
        'cochineal extract',
        'carminic acid',
        'e120',
        'natural red 4',
        'crimson lake',
        'carmin',
        'karmin',
        'carminio',
        'cochenille'
      ],
      category: IngredientCategory.insect,
      severity: IngredientSeverity.definite,
      explanation:
          'Red dye made from crushed cochineal beetles. Found in red candies, yogurt, and drinks.',
    ),
    Ingredient(
      name: 'Shellac (E904)',
      aliases: [
        'shellac',
        'e904',
        'confectioner\'s glaze',
        'pharmaceutical glaze',
        'gomme-laque',
        'schellack',
        'goma laca',
        'gommalacca',
        'food grade shellac',
        'resinous glaze'
      ],
      category: IngredientCategory.insect,
      severity: IngredientSeverity.definite,
      explanation:
          'Resin secreted by lac beetles, used as glazing on candies and fruit coating.',
    ),
    Ingredient(
      name: 'Beeswax (E901)',
      aliases: [
        'beeswax',
        'e901',
        'cera alba',
        'cire d\'abeille',
        'bienenwachs',
        'cera de abeja',
        'cera d\'api'
      ],
      category: IngredientCategory.insect,
      severity: IngredientSeverity.definite,
      explanation:
          'Wax from honeycomb, used as glazing on confectionery and fruit.',
    ),
    Ingredient(
      name: 'Lanolin (E913)',
      aliases: ['lanolin', 'e913', 'wool grease', 'wool wax', 'lanoline'],
      category: IngredientCategory.insect,
      severity: IngredientSeverity.definite,
      explanation: 'Grease from sheep\'s wool.',
    ),

    // ──────────────── E-NUMBERS (always animal) ────────────────
    Ingredient(
      name: 'E441',
      aliases: ['e441'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation:
          'Gelatin. E-number for gelatin derived from animal bones and skin.',
    ),
    Ingredient(
      name: 'E542',
      aliases: ['e542'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.definite,
      explanation: 'Edible bone phosphate from ground animal bones.',
    ),

    // ──────────────── POSSIBLY NON-VEG (source varies) ────────────────
    Ingredient(
      name: 'E471',
      aliases: [
        'e471',
        'mono- and diglycerides of fatty acids',
        'mono and diglycerides',
        'mono-and diglycerides'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation:
          'Can come from animal fat or vegetable oil. Packaging rarely clarifies the source. One of the most common additives in processed food.',
    ),
    Ingredient(
      name: 'E470',
      aliases: [
        'e470',
        'e470a',
        'e470b',
        'sodium stearate',
        'potassium stearate',
        'calcium stearate',
        'magnesium stearate'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation:
          'Salts of fatty acids that can be from animal or vegetable sources.',
    ),
    Ingredient(
      name: 'E472',
      aliases: ['e472', 'e472a', 'e472b', 'e472c', 'e472d', 'e472e', 'e472f'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation: 'Esters of mono- and diglycerides. May be from animal fat.',
    ),
    Ingredient(
      name: 'E473',
      aliases: ['e473', 'e474', 'e475', 'e476', 'e477', 'sucrose esters'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation: 'Sucrose esters of fatty acids. Animal fat source possible.',
    ),
    Ingredient(
      name: 'E481',
      aliases: [
        'e481',
        'e482',
        'e483',
        'e484',
        'e485',
        'sodium stearoyl lactylate',
        'calcium stearoyl lactylate'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation:
          'Stearoyl compounds that may contain animal-derived stearic acid.',
    ),
    Ingredient(
      name: 'E491',
      aliases: [
        'e491',
        'e492',
        'e493',
        'e494',
        'e495',
        'sorbitan monostearate',
        'sorbitan tristearate'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation: 'Sorbitan esters that may use animal-derived fatty acids.',
    ),
    Ingredient(
      name: 'Stearic Acid (E570)',
      aliases: ['e570', 'stearic acid', 'e571', 'e572', 'e573'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation:
          'Fatty acid that can come from animal fat (tallow) or vegetable sources.',
    ),
    Ingredient(
      name: 'Glycerol (E422)',
      aliases: ['e422', 'glycerol', 'glycerin', 'glycerine'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation: 'Can be derived from animal fat or vegetable sources.',
    ),
    Ingredient(
      name: 'Oleic Acid',
      aliases: ['oleic acid'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation:
          'Fatty acid that can come from animal fat (tallow) or vegetable sources.',
    ),
    Ingredient(
      name: 'Natural Flavoring',
      aliases: [
        'natural flavoring',
        'natural flavouring',
        'natural flavor',
        'natural flavour',
        'natural flavors',
        'natural flavours',
        'arôme naturel',
        'arômes naturels',
        'natürliches aroma',
        'natürliche aromen',
        'aroma natural',
        'aromi naturali'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation:
          'May be derived from meat, fish, or dairy. The source is not required to be specified in many countries.',
    ),
    Ingredient(
      name: 'Vitamin D3',
      aliases: ['vitamin d3', 'cholecalciferol', 'd3'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation:
          'Often derived from lanolin (sheep wool grease) or fish oil. Vegan D3 from lichen exists but is less common.',
    ),
    Ingredient(
      name: 'Lecithin (E322)',
      aliases: ['e322', 'lecithin'],
      category: IngredientCategory.egg,
      severity: IngredientSeverity.possible,
      explanation:
          'Can be from eggs or soy. "Soy lecithin" is vegetarian. Plain "lecithin" may be from eggs.',
    ),
    Ingredient(
      name: 'Lactic Acid Esters (E325-327)',
      aliases: [
        'e325',
        'e326',
        'e327',
        'sodium lactate',
        'potassium lactate',
        'calcium lactate'
      ],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation:
          'Lactate salts. Can be derived from milk but usually from fermentation. Low risk.',
    ),
    Ingredient(
      name: 'E153',
      aliases: ['e153', 'vegetable carbon'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation: 'Vegetable carbon that may have non-vegetarian origins.',
    ),
    Ingredient(
      name: 'E161g',
      aliases: ['e161g', 'canthaxanthin'],
      category: IngredientCategory.fish,
      severity: IngredientSeverity.possible,
      explanation: 'Pigment that may come from crustaceans and fish.',
    ),
    Ingredient(
      name: 'Ascorbyl Palmitate (E304)',
      aliases: ['e304', 'ascorbyl palmitate', 'ascorbyl stearate'],
      category: IngredientCategory.meat,
      severity: IngredientSeverity.possible,
      explanation: 'May use animal-derived fat in production.',
    ),
  ];

  static const Set<String> _safeFalsePositives = {
    'agar',
    'agar-agar',
    'agar agar',
    'lactic acid',
    'soy lecithin',
    'soya lecithin',
    'sunflower lecithin',
    'pectin',
    'xanthan gum',
    'cream of tartar',
    'cocoa butter',
    'shea butter',
    'carrageenan',
    'guar gum',
    'locust bean gum',
    'tartaric acid',
    'citric acid',
    'ascorbic acid',
    'tocopherol',
    'vitamin e',
    'cellulose',
    'microcrystalline cellulose',
    'carnauba wax',
    'coconut oil',
    'palm oil',
    'palm fat',
    'vegetable oil',
    'vegetable fat',
    'plant-based',
    'vegan',
    'vegetable glycerin',
    'vegetable glycerine',
    'soy protein',
    'soya protein',
    'pea protein',
    'wheat protein',
    'rice protein',
    'vegetable stock',
    'vegetable broth',
    'vegetable bouillon',
    'mushroom extract',
    'yeast extract',
    'malt extract',
    'barley malt',
  };

  void _buildLookup() {
    _lookup = {};
    _substringIngredients = [];

    for (final ingredient in _allIngredients) {
      for (final alias in ingredient.aliases) {
        final key = alias.toLowerCase().trim();
        _lookup[key] = ingredient;
      }
      _substringIngredients.add(ingredient);
    }
  }

  Ingredient? exactMatch(String text) {
    return _lookup[text.toLowerCase().trim()];
  }

  bool isSafeFalsePositive(String text) {
    return _safeFalsePositives.contains(text.toLowerCase().trim());
  }

  Ingredient? substringMatch(String text) {
    final lower = text.toLowerCase().trim();

    if (isSafeFalsePositive(lower)) return null;

    for (final ingredient in _substringIngredients) {
      for (final alias in ingredient.aliases) {
        if (alias.length >= 4 && lower.contains(alias)) {
          return ingredient;
        }
      }
    }
    return null;
  }

  List<Ingredient> get allIngredients => _allIngredients;
}
