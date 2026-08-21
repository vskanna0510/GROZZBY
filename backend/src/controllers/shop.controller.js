const CATEGORIES = [
  {
    id: 'cat_fruits_veg',
    name: 'Fruits & Veggies',
    icon: '🍎',
    itemCount: 42,
    image: 'assets/images/summer_banner.jpg',
    description: 'Fresh organic fruits, green leafy vegetables & hydroponic produce',
  },
  {
    id: 'cat_dairy_eggs',
    name: 'Dairy & Eggs',
    icon: '🥛',
    itemCount: 28,
    image: 'assets/images/category_home.jpg',
    description: 'Farm-fresh milk, organic eggs, artisan cheeses & probiotic yogurts',
  },
  {
    id: 'cat_bakery',
    name: 'Bakery & Bread',
    icon: '🍞',
    itemCount: 19,
    image: 'assets/images/category_accessories.jpg',
    description: 'Artisan sourdough, French butter croissants & whole wheat loaves',
  },
  {
    id: 'cat_beverages',
    name: 'Beverages & Juices',
    icon: '🧃',
    itemCount: 35,
    image: 'assets/images/category_beauty.jpg',
    description: 'Cold-pressed juices, sparkling waters, kombucha & roasted coffees',
  },
  {
    id: 'cat_snacks',
    name: 'Snacks & Munchies',
    icon: '🍿',
    itemCount: 31,
    image: 'assets/images/category_fashion.jpg',
    description: 'Gourmet roasted nuts, organic popcorn, trail mixes & chips',
  },
  {
    id: 'cat_meat_seafood',
    name: 'Meat & Seafood',
    icon: '🥩',
    itemCount: 24,
    image: 'assets/images/category_shoes.jpg',
    description: 'Fresh Atlantic salmon, pasture-raised meats & fresh catch fillets',
  },
  {
    id: 'cat_organic',
    name: 'Organic Essentials',
    icon: '🥑',
    itemCount: 18,
    image: 'assets/images/summer_collection.jpg',
    description: 'Certified organic whole grains, raw honey & superfoods',
  },
  {
    id: 'cat_household',
    name: 'Household Care',
    icon: '🧼',
    itemCount: 22,
    image: 'assets/images/category_home.jpg',
    description: 'Eco-friendly cleaners, bamboo tissues & zero-waste home essentials',
  },
  {
    id: 'cat_electronics',
    name: 'Electronics',
    icon: '🎧',
    itemCount: 12,
    image: 'assets/images/category_electronics.jpg',
    description: 'Premium headphones, smart watches, mechanical keyboards & audio gear',
  },
  {
    id: 'cat_fashion',
    name: 'Fashion',
    icon: '👗',
    itemCount: 16,
    image: 'assets/images/category_fashion.jpg',
    description: 'Sustainable linen dresses, denim jackets & seasonal collections',
  },
  {
    id: 'cat_beauty',
    name: 'Beauty',
    icon: '✨',
    itemCount: 14,
    image: 'assets/images/category_beauty.jpg',
    description: 'Clean skincare serums, botanical face oils & organic cosmetics',
  },
  {
    id: 'cat_home',
    name: 'Home & Living',
    icon: '🏡',
    itemCount: 18,
    image: 'assets/images/category_home.jpg',
    description: 'Artisan ceramic desk lamps, linen cushions & modern homeware',
  },
  {
    id: 'cat_accessories',
    name: 'Accessories',
    icon: '⌚',
    itemCount: 10,
    image: 'assets/images/category_accessories.jpg',
    description: 'Minimalist leather watches, classic chronographs & timeless pieces',
  },
  {
    id: 'cat_shoes',
    name: 'Shoes',
    icon: '👟',
    itemCount: 12,
    image: 'assets/images/category_shoes.jpg',
    description: 'Comfort athletic sneakers, running shoes & casual lifestyle footwear',
  },
];

const PRODUCTS = [
  {
    id: 'prod_1',
    name: 'Fresh Organic Avocados',
    categoryId: 'cat_fruits_veg',
    categoryName: 'Fruits & Veggies',
    imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500&auto=format&fit=crop&q=80',
    price: 180.0,
    originalPrice: 240.0,
    unit: '2 pcs (approx. 400g)',
    rating: 4.9,
    reviewCount: 248,
    description: 'Hand-picked premium Hass avocados, perfectly creamy and rich in healthy fats and potassium.',
    tag: 'Best Seller',
    isFeatured: true,
    isFlashSale: true,
    inStock: true,
  },
  {
    id: 'prod_2',
    name: 'Crisp Red Royal Apples',
    categoryId: 'cat_fruits_veg',
    categoryName: 'Fruits & Veggies',
    imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500&auto=format&fit=crop&q=80',
    price: 140.0,
    originalPrice: 180.0,
    unit: '1 kg (approx. 5-6 pcs)',
    rating: 4.8,
    reviewCount: 184,
    description: 'Sweet, juicy, and crunchy premium apples straight from Himachal orchard farms.',
    tag: 'Fresh Pick',
    isFeatured: true,
    isFlashSale: true,
    inStock: true,
  },
  {
    id: 'prod_sony_wh1000xm5',
    name: 'SONY WH-1000XM5 Wireless Headphones',
    categoryId: 'cat_electronics',
    categoryName: 'Electronics',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=80',
    price: 120.0,
    originalPrice: 150.0,
    unit: '1 unit (Black Edition • ANC)',
    rating: 4.9,
    reviewCount: 312,
    description: 'Industry-leading noise cancelling headphones with two processors and eight microphones.',
    tag: 'Aura Signature',
    isFeatured: true,
    isFlashSale: true,
    inStock: true,
  },
  {
    id: 'prod_fossil_minimalist',
    name: 'FOSSIL Minimalist Leather Watch',
    categoryId: 'cat_accessories',
    categoryName: 'Accessories',
    imageUrl: 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=500&auto=format&fit=crop&q=80',
    price: 120.0,
    originalPrice: 140.0,
    unit: '1 unit (Beige Leather)',
    rating: 4.8,
    reviewCount: 194,
    description: 'Sleek, minimalist analog watch with genuine leather strap and stainless steel case.',
    tag: 'Fossil',
    isFeatured: true,
    isFlashSale: true,
    inStock: true,
  },
  {
    id: 'prod_summer_dress',
    name: 'Summer Floral Linen Dress',
    categoryId: 'cat_fashion',
    categoryName: 'Fashion',
    imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500&auto=format&fit=crop&q=80',
    price: 85.0,
    originalPrice: 120.0,
    unit: '1 piece (Size M / L)',
    rating: 4.8,
    reviewCount: 96,
    description: 'Breathable lightweight organic linen sundress with artisanal floral embroidery.',
    tag: 'Aura Signature',
    isFeatured: true,
    inStock: true,
  },
  {
    id: 'prod_nike_air_max',
    name: 'Nike Air Max Pulse Running Shoes',
    categoryId: 'cat_shoes',
    categoryName: 'Shoes',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=80',
    price: 140.0,
    originalPrice: 180.0,
    unit: '1 pair (UK 8 / 9 / 10)',
    rating: 4.9,
    reviewCount: 350,
    description: 'Responsive point-loaded Air cushioning with durable breathable mesh upper for daily comfort.',
    tag: 'Nike',
    isFeatured: true,
    isFlashSale: true,
    inStock: true,
  },
  {
    id: 'prod_rose_serum',
    name: 'Botanical Rose Hydrating Glow Serum',
    categoryId: 'cat_beauty',
    categoryName: 'Beauty',
    imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=500&auto=format&fit=crop&q=80',
    price: 55.0,
    originalPrice: 75.0,
    unit: '50 ml glass dropper',
    rating: 4.8,
    reviewCount: 140,
    description: 'Deep hydration infused with pure Damask rose water, niacinamide, and hyaluronic acid.',
    tag: 'Essence',
    isFeatured: true,
    inStock: true,
  },
  {
    id: 'prod_ceramic_lamp',
    name: 'Warm Minimalist Ceramic Desk Lamp',
    categoryId: 'cat_home',
    categoryName: 'Home & Living',
    imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=500&auto=format&fit=crop&q=80',
    price: 80.0,
    originalPrice: 110.0,
    unit: '1 unit (Warm LED bulb incl.)',
    rating: 4.8,
    reviewCount: 88,
    description: 'Handcrafted matte textured ceramic base with natural linen lampshade for warm ambient lighting.',
    tag: 'Studio M',
    isFeatured: true,
    inStock: true,
  },
];

const STORES = [
  {
    id: 'store_1',
    name: 'Grozzby Flagship Store - Downtown',
    address: '842 Aurora Blvd, Suite 4, San Francisco, CA 94110',
    phone: '+1 (415) 555-0198',
    distance: '1.2 km away',
    rating: 4.9,
    reviewCount: 320,
    timings: 'Open Daily • 7:00 AM - 11:00 PM',
    hasExpressDelivery: true,
    hasCurbsidePickup: true,
  },
  {
    id: 'store_2',
    name: 'Grozzby Organic Express - Financial District',
    address: '100 Market St, Floor 1, San Francisco, CA 94105',
    phone: '+1 (415) 555-0244',
    distance: '3.4 km away',
    rating: 4.8,
    reviewCount: 195,
    timings: 'Open Daily • 6:30 AM - 10:00 PM',
    hasExpressDelivery: true,
    hasCurbsidePickup: true,
  },
];

export async function getCategories(req, res) {
  res.json({
    success: true,
    data: CATEGORIES,
    total: CATEGORIES.length,
  });
}

export async function getProducts(req, res) {
  const { category, search, sort, minPrice, maxPrice, inStockOnly } = req.query;

  let results = [...PRODUCTS];

  if (category) {
    const catLower = category.toLowerCase().replace('cat_', '');
    results = results.filter((p) => {
      const pCat = p.categoryId.toLowerCase().replace('cat_', '');
      return pCat === catLower || p.categoryName.toLowerCase().includes(catLower);
    });
  }

  if (search) {
    const q = search.toLowerCase();
    results = results.filter(
      (p) =>
        p.name.toLowerCase().includes(q) ||
        p.categoryName.toLowerCase().includes(q) ||
        (p.tag && p.tag.toLowerCase().includes(q))
    );
  }

  if (minPrice) {
    results = results.filter((p) => p.price >= parseFloat(minPrice));
  }

  if (maxPrice) {
    results = results.filter((p) => p.price <= parseFloat(maxPrice));
  }

  if (inStockOnly === 'true') {
    results = results.filter((p) => p.inStock);
  }

  if (sort === 'price_asc') {
    results.sort((a, b) => a.price - b.price);
  } else if (sort === 'price_desc') {
    results.sort((a, b) => b.price - a.price);
  } else if (sort === 'rating') {
    results.sort((a, b) => b.rating - a.rating);
  }

  res.json({
    success: true,
    data: results,
    total: results.length,
  });
}

export async function getProductById(req, res) {
  const { id } = req.params;
  const product = PRODUCTS.find((p) => p.id === id);

  if (!product) {
    return res.status(404).json({ success: false, error: 'Product not found' });
  }

  res.json({ success: true, data: product });
}

export async function getStores(req, res) {
  res.json({
    success: true,
    data: STORES,
    total: STORES.length,
  });
}
