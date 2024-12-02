<script lang="ts">
  import { browser } from '$app/environment';
  import SideNav from '$lib/sideNav.svelte';
  import Header from '$lib/header.svelte';
  import ItemCard from '$lib/itemCard.svelte';
  import Cart from '../cart/+page.svelte';
  import { onMount } from 'svelte';
  import { userStore } from '$lib/auth';
  import { goto } from '$app/navigation';
  import { checkAuth } from '$lib/auth';
  import { productAvailability, availabilityLoading } from '$lib/stores/productAvailability';
  import { ApiService } from '$lib/services/api';

  type Product = {
    product_id: number;
    name: string;
    image: string;
    price: number;
    category: string;
    size?: string;
    isAvailable?: boolean;
  };
  type CartItem = {
    product_id: number;
    id: number;
    name: string;
    image: string;
    price: number;
    category: string;
    quantity: number;
  };

  type GroupedProduct = {
    name: string;
    image: string;
    category: string;
    variants: Product[];
  };

  let y = 0;
  let innerWidth = 0;
  let innerHeight = 0;
  let products: Product[] = [];
  let cartItems: CartItem[] = [];
  let selectedCategory = 'All';
  let searchQuery = '';
  let userId: number;
  let showSizeModal = false;
  let selectedProduct: GroupedProduct | null = null;
  let showMobileCart = false;

  userStore.subscribe(user => {
    userId = user.userId;
  });

  onMount(async () => {
    if (!checkAuth()) {
      goto('/');
    }
    await fetchItems();
    await fetchCartItems();
  });

  async function fetchItems() {
    try {
        const data = await ApiService.get<Product[]>('get-menu-items');
        products = data.map(p => ({ 
            ...p,
            price: Number(p.price),
            product_id: p.product_id || p.id,
            image: p.image || ''
        }));
    } catch (error) {
        console.error('Error fetching items:', error);
        products = [];
    }
  }

  async function fetchCartItems() {
    try {
      const result = await ApiService.get<CartItem[]>(`get-cart-items`, { user_id: userId.toString() });
      if (result.status && Array.isArray(result.data)) {
        cartItems = result.data.map(item => ({
          product_id: item.product_id,
          id: item.product_id,
          name: item.name,
          price: Number(item.price),
          quantity: Number(item.quantity),
          image: item.image,
          category: item.category
        }));
      } else {
        cartItems = [];
      }
    } catch (error) {
      console.error('Error fetching cart items:', error);
      cartItems = [];
    }
  }

  async function checkInventoryStock(product: Product, quantity: number = 1): Promise<{ available: boolean; message: string }> {
    try {
      const result = await ApiService.get<{available: boolean; message: string}>('get-product-ingredients', {
        product_id: product.product_id.toString()
      });
      
      if (!result.status || !result.data || result.data.length === 0) {
        return { available: false, message: 'No Recipe Set' };
      }

      // Check if any ingredient is insufficient
      for (const ingredient of result.data) {
        const requiredQuantity = ingredient.quantity_needed * quantity;
        if (ingredient.stock_quantity < requiredQuantity) {
          return { available: false, message: 'Insufficient Stock' };
        }
      }
      
      return { available: true, message: '' };
    } catch (error) {
      console.error('Error checking inventory:', error);
      return { available: false, message: 'Error' };
    }
  }

  async function updateCartQuantity(productId: number, newQuantity: number) {
    try {
      const result = await ApiService.get<{
        is_available: boolean, 
        max_quantity: number, 
        debug_info: any
      }>(
        'check-ingredient-availability',
        {
          product_id: productId.toString(),
          quantity: newQuantity.toString()
        }
      );
      
      console.log('Update Cart Quantity Check:', {
        productId,
        newQuantity,
        result
      });
      
      if (!result.is_available || newQuantity > result.max_quantity) {
        alert(`Cannot update quantity: Maximum available is ${result.max_quantity}`);
        return false;
      }
      
      cartItems = cartItems.map(item =>
        item.id === productId
          ? { ...item, quantity: newQuantity }
          : item
      );

      if (browser) {
        localStorage.setItem(`cart_${$userStore.userId}`, JSON.stringify(cartItems));
      }
      
      return true;
    } catch (error) {
      console.error('Error updating cart quantity:', error);
      return false;
    }
  }

  async function addToCart(product: Product) {
    const existingItem = cartItems.find(item => item.id === product.product_id);
    const newQuantity = existingItem ? existingItem.quantity + 1 : 1;
    
    try {
      const result = await ApiService.get<{
        is_available: boolean, 
        max_quantity: number, 
        debug_info: any
      }>(
        'check-ingredient-availability',
        {
          product_id: product.product_id.toString(),
          quantity: newQuantity.toString()
        }
      );
      
      console.log('Add to Cart Check:', {
        product,
        newQuantity,
        result
      });
      
      if (!result.is_available || newQuantity > result.max_quantity) {
        alert(`Cannot add more of this item: Maximum available is ${result.max_quantity}`);
        return;
      }
      
      if (existingItem) {
        const updated = await updateCartQuantity(product.product_id, newQuantity);
        if (!updated) return;
      } else {
        cartItems = [
          ...cartItems,
          {
            product_id: product.product_id,
            id: product.product_id,
            name: product.name,
            price: product.price,
            quantity: 1,
            image: product.image,
            category: product.category
          },
        ];

        if (browser) {
          localStorage.setItem(`cart_${$userStore.userId}`, JSON.stringify(cartItems));
        }
      }
    } catch (error) {
      console.error('Error checking availability:', error);
      alert('Unable to add item to cart');
    }
  }

  async function removeFromCart(productId: number) {
    try {
        const response = await fetch('/api/remove-from-cart', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                product_id: productId,
                user_id: userId
            })
        });

        const result = await response.json();
        if (result.status) {
            cartItems = cartItems.filter(item => item.product_id !== productId);
        } else {
            alert(result.message);
        }
    } catch (error) {
        console.error('Error removing item from cart:', error);
        alert('Failed to remove item from cart');
    }
  }

  function updateQuantity(productId: number, newQuantity: number) {
    if (newQuantity < 1) {
      removeFromCart(productId);
      return;
    }
    cartItems = cartItems.map(item =>
      item.product_id === productId 
        ? { ...item, quantity: newQuantity }
        : item
    );
  }

  function getTotal() {
    return cartItems.reduce((sum, item) => sum + (Number(item.price) * item.quantity), 0);
  }

  $: groupedProducts = products.reduce((groups: { [key: string]: GroupedProduct }, product) => {
    const key = `${product.name}-${product.category}`;
    if (!groups[key]) {
      groups[key] = {
        name: product.name,
        image: product.image,
        category: product.category,
        variants: []
      };
    }
    groups[key].variants.push(product);
    return groups;
  }, {});

  $: filteredGroupedProducts = Object.values(groupedProducts)
    .filter(group => selectedCategory === 'All' || group.category === selectedCategory)
    .filter(group => group.name.toLowerCase().includes(searchQuery.toLowerCase()));

  $: categories = ['All', ...new Set(products.map(p => p.category))];
  $: total = getTotal();

  async function handleProductClick(group: GroupedProduct) {
    if (['Drinks', 'Pizza'].includes(group.category) && group.variants.length > 1) {
      selectedProduct = group;
      showSizeModal = true;
    } else {
      await addToCart(group.variants[0]);
    }
  }

  async function handleSizeSelection(variant: Product) {
    const stockCheck = await checkInventoryStock(variant);
    if (!stockCheck.available) {
        alert(stockCheck.message);
        return;
    }
    
    showSizeModal = false;
    await addToCart(variant);
    selectedProduct = null;
  }

  function toggleMobileCart() {
    showMobileCart = !showMobileCart;
  }

  async function checkBatchAvailability(products: Product[]) {
    try {
        availabilityLoading.set(true);
        const productIds = products.map(p => p.product_id);
        const response = await fetch(`/api/get-batch-product-ingredients&product_ids=${JSON.stringify(productIds)}`);
        const result = await response.json();
        
        if (result.status && result.data) {
            const availability: Record<number, boolean> = {};
            Object.entries(result.data).forEach(([productId, data]: [string, any]) => {
                availability[Number(productId)] = data.isAvailable;
            });
            productAvailability.set(availability);
        }
    } catch (error) {
        console.error('Error checking batch availability:', error);
    } finally {
        availabilityLoading.set(false);
    }
  }

  // Call this when products are loaded
  $: if (products.length > 0) {
    checkBatchAvailability(products);
  }
</script>

<Header {y} {innerHeight} />
<div class="container">
  <div class="content">
    <SideNav 
      activeMenu="pos"
      bind:selectedCategory={selectedCategory}
      onToggleCart={toggleMobileCart}
    />
    
    <div class="main-content">
      <!-- Search Bar -->
      <div class="search-controls">
        <div class="search-bar">
          <input
            type="text"
            bind:value={searchQuery}
            placeholder="Search products..."
            class="search-input"
          />
        </div>
        
        <!-- Category Labels -->
        <div class="category-tabs">
          {#each categories as category}
            <button 
              class="category-tab {selectedCategory === category ? 'active' : ''}"
              on:click={() => selectedCategory = category}
            >
              {category}
            </button>
          {/each}
        </div>
      </div>

      <!-- Products Grid -->
      <div class="products-container">
        <div class="products-section">
          <div class="grid grid-cols-3 gap-4">
            {#each filteredGroupedProducts as group}
              <button 
                type="button" 
                class="product-card"
              >
                <ItemCard 
                  product={{
                    product_id: group.variants[0].product_id,
                    name: group.name,
                    image: group.variants[0].image,
                    price: group.variants[0].price.toString(),
                    category: group.category
                  }} 
                  onAddToCart={() => handleProductClick(group)}
                />
              </button>
            {/each}
          </div>
        </div>
      </div>
    </div>

    <!-- Desktop Cart -->
    <div class="hidden md:block">
      <Cart 
        {cartItems} 
        {userId}
        onUpdateQuantity={updateQuantity}
        onRemoveFromCart={removeFromCart}
        {total}
        on:cartCleared={() => {
            cartItems = [];
            if (browser) {
                localStorage.removeItem(`cart_${$userStore.userId}`);
            }
        }}
      />
    </div>
  </div>
</div>

{#if showSizeModal && selectedProduct}
  <div class="modal-backdrop" on:click={() => {
    showSizeModal = false;
    selectedProduct = null;
  }}>
    <div class="modal-content" on:click|stopPropagation>
      <div class="modal-header">
        <h2 class="text-xl font-bold">Select Size for {selectedProduct.name}</h2>
        <button 
          class="close-modal-btn"
          on:click={() => {
            showSizeModal = false;
            selectedProduct = null;
          }}
        >
          ×
        </button>
      </div>
      <div class="grid gap-4">
        {#each selectedProduct.variants as variant}
          <button
            class="size-option"
            on:click={() => handleSizeSelection(variant)}
          >
            {variant.size} - ₱{variant.price}
          </button>
        {/each}
      </div>
    </div>
  </div>
{/if}

<!-- Mobile Cart Modal -->
{#if showMobileCart}
  <div class="fixed inset-0 z-50 md:hidden">
    <div class="absolute inset-0 bg-black bg-opacity-50" on:click={toggleMobileCart}></div>
    <div class="mobile-cart-container">
      <div class="h-full overflow-y-auto">
        <div class="p-4 border-b">
          <div class="flex justify-between items-center">
            <h2 class="text-xl font-bold">Your Cart</h2>
            <button 
              class="text-gray-500 hover:text-gray-700"
              on:click={toggleMobileCart}
            >
              <i class="fas fa-times"></i>
            </button>
          </div>
        </div>
        <Cart 
          {cartItems} 
          {userId}
          onUpdateQuantity={updateQuantity}
          onRemoveFromCart={removeFromCart}
          {total}
          on:cartCleared={() => {
              cartItems = [];
              if (browser) {
                  localStorage.removeItem(`cart_${$userStore.userId}`);
              }
              toggleMobileCart();
          }}
        />
      </div>
    </div>
  </div>
{/if}

<style>
  .search-controls {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .search-bar {
    width: 100%;
  }

  .search-input {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 2px solid #e5e7eb;
    border-radius: 0.5rem;
    font-size: 1rem;
    transition: all 0.2s;
  }

  .search-input:focus {
    outline: none;
    border-color: #47cb50;
    box-shadow: 0 0 0 3px rgba(71, 203, 80, 0.1);
  }

  .category-tabs {
    display: flex;
    gap: 0.5rem;
    overflow-x: auto;
    padding: 0.5rem 0;
    scrollbar-width: none; /* Firefox */
    -ms-overflow-style: none; /* IE and Edge */
    -webkit-overflow-scrolling: touch;
  }

  .category-tabs::-webkit-scrollbar {
    display: none; /* Chrome, Safari, Opera */
  }

  .category-tab {
    padding: 0.5rem 1rem;
    background: #f3f4f6;
    border: none;
    border-radius: 0.5rem;
    white-space: nowrap;
    cursor: pointer;
    transition: all 0.2s;
    font-size: 0.875rem;
    color: #4b5563;
  }

  .category-tab:hover {
    background: #e5e7eb;
  }

  .category-tab.active {
    background: #47cb50;
    color: white;
  }

  .content {
    display: flex;
    height: calc(100vh - 4rem);
    margin-top: 4rem;
    overflow: hidden;
  }

  .main-content {
    flex: 1;
    padding: 1rem;
    display: flex;
    flex-direction: column;
    height: 100%;
    overflow-y: auto;
    scrollbar-width: thin;
    scrollbar-color: #47cb50 #f5f5f5;

  }

  .main-content::-webkit-scrollbar {
    width: 8px;
  }

  .main-content::-webkit-scrollbar-track {
    background: #f5f5f5;
  }

  .main-content::-webkit-scrollbar-thumb {
    background: #47cb50;
    border-radius: 4px;
  }

  .products-container {
    flex: 1;
    overflow-y: auto;
    min-height: 0;
    scrollbar-width: thin; /* Firefox */
    scrollbar-color: #47cb50 #f5f5f5; /* Firefox */
  }

  .products-container::-webkit-scrollbar {
    width: 8px; /* Chrome, Safari, Opera */
  }

  .products-container::-webkit-scrollbar-track {
    background: #f5f5f5;
  }

  .products-container::-webkit-scrollbar-thumb {
    background: #47cb50;
    border-radius: 4px;
  }

  .products-section {
    padding: 1rem;
  }

  .category-filter {
    display: flex;
    gap: 0.5rem;
    padding: 1rem;
    overflow-x: auto;
    background: white;
    border-radius: 0.5rem;
    margin-bottom: 1rem;
  }

  .category-btn {
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    background: #f3f4f6;
    white-space: nowrap;
  }

  .category-btn.active {
    background: #47cb50;
    color: white;
  }

  .product-card {
    cursor: pointer;
    transition: transform 0.2s;
  }

  .product-card:hover {
    transform: translateY(-2px);
  }

  .modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }

  .modal-content {
    background: white;
    padding: 2rem;
    border-radius: 0.5rem;
    width: 90%;
    max-width: 400px;
  }

  .size-option {
    width: 100%;
    padding: 1rem;
    background: #f3f4f6;
    border-radius: 0.5rem;
    text-align: center;
    transition: background-color 0.2s;
  }

  .size-option:hover {
    background: #47cb50;
    color: white;
  }

  .container {
    width: 100%;
    height: 100vh;
    background-color: #f5f5f5;
    overflow: hidden;
  }

  .content {
    display: flex;
    height: calc(100vh - 4rem);
    margin-top: 4rem;
    overflow: hidden;
  }

  .main-content {
    flex: 1;
    padding: 1rem;
    display: flex;
    flex-direction: column;
    height: 100%;
    overflow-y: auto;
    scrollbar-width: thin;
    scrollbar-color: #47cb50 #f5f5f5;
    margin-top: 20px;
  }

  /* Responsive grid for products */
  :global(.grid-cols-3) {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 10px;
    justify-items: center;

  }

  @media (max-width: 768px) {
    .content {
      margin-top: 3rem;
    }

    .main-content {
      padding: 0.5rem;
    }

    :global(.grid-cols-3) {
      grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
      gap: 0.5rem;
    }

    .category-tabs {
      margin: 0 -0.5rem;
      padding: 0.5rem;
    }
  }

  .mobile-cart-container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 90%;
    max-width: 400px;
    max-height: 90vh;
    background: white;
    border-radius: 0.5rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  @media (max-width: 768px) {
    .mobile-cart-container {
      width: 95%;
      max-height: 80vh;
    }
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
  }

  .close-modal-btn {
    font-size: 1.5rem;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0.5rem;
    color: #666;
    transition: color 0.2s;
  }

  .close-modal-btn:hover {
    color: #000;
  }
</style>