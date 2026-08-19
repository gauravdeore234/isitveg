class ENumberInfo {
  final String number;
  final String name;
  final String source;
  final bool definitelyAnimal;

  const ENumberInfo({
    required this.number,
    required this.name,
    required this.source,
    required this.definitelyAnimal,
  });
}

const Map<String, ENumberInfo> eNumberDatabase = {
  'e120': ENumberInfo(
    number: 'E120',
    name: 'Cochineal / Carmine',
    source: 'Crushed cochineal beetles',
    definitelyAnimal: true,
  ),
  'e441': ENumberInfo(
    number: 'E441',
    name: 'Gelatin',
    source: 'Animal bones and skin',
    definitelyAnimal: true,
  ),
  'e542': ENumberInfo(
    number: 'E542',
    name: 'Edible Bone Phosphate',
    source: 'Ground animal bones',
    definitelyAnimal: true,
  ),
  'e901': ENumberInfo(
    number: 'E901',
    name: 'Beeswax',
    source: 'Honeycomb',
    definitelyAnimal: true,
  ),
  'e904': ENumberInfo(
    number: 'E904',
    name: 'Shellac',
    source: 'Lac insect secretions',
    definitelyAnimal: true,
  ),
  'e913': ENumberInfo(
    number: 'E913',
    name: 'Lanolin',
    source: "Sheep's wool",
    definitelyAnimal: true,
  ),
  'e920': ENumberInfo(
    number: 'E920',
    name: 'L-Cysteine',
    source: 'Animal hair, feathers, or hooves',
    definitelyAnimal: true,
  ),
  'e1105': ENumberInfo(
    number: 'E1105',
    name: 'Lysozyme',
    source: 'Chicken egg whites',
    definitelyAnimal: true,
  ),
  'e471': ENumberInfo(
    number: 'E471',
    name: 'Mono- and Diglycerides',
    source: 'Animal fat or vegetable oil (source varies)',
    definitelyAnimal: false,
  ),
  'e470a': ENumberInfo(
    number: 'E470a',
    name: 'Sodium/Potassium Stearate',
    source: 'Animal or vegetable fatty acids',
    definitelyAnimal: false,
  ),
  'e470b': ENumberInfo(
    number: 'E470b',
    name: 'Magnesium Stearate',
    source: 'Animal or vegetable fatty acids',
    definitelyAnimal: false,
  ),
  'e472a': ENumberInfo(
    number: 'E472a',
    name: 'Acetic Acid Esters of Mono- and Diglycerides',
    source: 'Possibly animal fat',
    definitelyAnimal: false,
  ),
  'e472b': ENumberInfo(
    number: 'E472b',
    name: 'Lactic Acid Esters of Mono- and Diglycerides',
    source: 'Possibly animal fat',
    definitelyAnimal: false,
  ),
  'e472c': ENumberInfo(
    number: 'E472c',
    name: 'Citric Acid Esters of Mono- and Diglycerides',
    source: 'Possibly animal fat',
    definitelyAnimal: false,
  ),
  'e472e': ENumberInfo(
    number: 'E472e',
    name: 'DATEM',
    source: 'Possibly animal fat',
    definitelyAnimal: false,
  ),
  'e422': ENumberInfo(
    number: 'E422',
    name: 'Glycerol',
    source: 'Animal fat or vegetable sources',
    definitelyAnimal: false,
  ),
  'e570': ENumberInfo(
    number: 'E570',
    name: 'Stearic Acid',
    source: 'Animal fat or vegetable sources',
    definitelyAnimal: false,
  ),
  'e322': ENumberInfo(
    number: 'E322',
    name: 'Lecithin',
    source: 'Eggs or soy (source varies)',
    definitelyAnimal: false,
  ),
  'e640': ENumberInfo(
    number: 'E640',
    name: 'Glycine',
    source: 'Often from gelatin, may be synthetic',
    definitelyAnimal: false,
  ),
  'e304': ENumberInfo(
    number: 'E304',
    name: 'Ascorbyl Palmitate',
    source: 'May use animal-derived fat',
    definitelyAnimal: false,
  ),
  'e481': ENumberInfo(
    number: 'E481',
    name: 'Sodium Stearoyl Lactylate',
    source: 'May contain animal-derived stearic acid',
    definitelyAnimal: false,
  ),
  'e482': ENumberInfo(
    number: 'E482',
    name: 'Calcium Stearoyl Lactylate',
    source: 'May contain animal-derived stearic acid',
    definitelyAnimal: false,
  ),
};
