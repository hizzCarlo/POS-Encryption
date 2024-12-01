<script lang="ts">
  import { goto } from '$app/navigation';
  export let activeMenu: string;
  export let selectedCategory: string = 'All';
  export let onToggleCart: () => void;
  let isPosActive = activeMenu === "pos";
  let isInventoryActive = activeMenu === "inventory";

  function selectCategory(category: string): void {
    if (isPosActive) {
      selectedCategory = category;
    }
  }
</script>

<div class="flex flex-row h-[90vh] w-auto flex-shrink-0 pl-4 pr-2 py-2 mt-5">
  <div class="flex flex-col items-center py-2 flex-shrink-0 w-20 bg-green-500 rounded-2xl h-full">
    <button 
      class="md:hidden flex items-center justify-center h-12 w-12 text-white rounded-full hover:bg-green-400 relative"
      on:click={onToggleCart}
      aria-label="Toggle Cart"
    >
      <i class="fa-solid fa-mug-saucer"></i>
    </button>
    <a class="hidden md:flex items-center justify-center h-12 w-12 text-green-700 rounded-full" aria-label="Logo">
      <i class="fa-solid fa-mug-saucer"></i>
    </a>
    <ul class="flex flex-col space-y-2 mt-12">
      <li>
        <a class="flex items-center" on:click={() => selectCategory('All')} aria-label="All Products">
          <span class={"bg-green-300 shadow-lg text-white flex items-center justify-center h-12 w-12 rounded-full hover:bg-green-400 hover:cursor-pointer text-green-100 " + (selectedCategory === 'All' ? "bg-green-400" : "")}>
            <i class="fa-solid fa-ellipsis"></i>
          </span>
        </a>
      </li>
      <li>
        <a class="flex items-center" on:click={() => selectCategory('Pizza')} aria-label="Pizza">
          <span class={"flex items-center justify-center text-green-100 hover:bg-green-400 hover:cursor-pointer h-12 w-12 rounded-full " + (selectedCategory === 'Pizza' ? "bg-green-400" : "")}>
            <i class="fa-solid fa-pizza-slice"></i>
          </span>
        </a>
      </li>
      <li>
        <a class="flex items-center" on:click={() => selectCategory('Burger & Fries')} aria-label="Burger">
          <span class={"flex items-center justify-center text-green-100 hover:bg-green-400 hover:cursor-pointer h-12 w-12 rounded-full " + (selectedCategory === 'Burger & Fries' ? "bg-green-400" : "")}>
            <i class="fa-solid fa-burger"></i>
          </span>
        </a>
      </li>
      <li>
        <a class="flex items-center" on:click={() => selectCategory('Nachos')} aria-label="Nachos">
          <span class={"flex items-center justify-center text-green-100 hover:bg-green-400 hover:cursor-pointer h-12 w-12 rounded-full " + (selectedCategory === 'Nachos' ? "bg-green-400" : "")}>
            <i class="fa-solid fa-cookie-bite"></i>
          </span>
        </a>
      </li>
      <li>
        <a class="flex items-center" on:click={() => selectCategory('Drinks')} aria-label="Drinks">
          <span class={"flex items-center justify-center text-green-100 hover:bg-green-400 hover:cursor-pointer h-12 w-12 rounded-full " + (selectedCategory === 'Drinks' ? "bg-green-400" : "")}>
            <i class="fa-solid fa-whiskey-glass"></i>
          </span>
        </a>
      </li>
      <li>
        <a class="flex items-center" on:click={() => selectCategory('Chocolate Series')} aria-label="Desserts">
          <span class={"flex items-center justify-center text-green-100 hover:bg-green-400 hover:cursor-pointer h-12 w-12 rounded-full " + (selectedCategory === 'Chocolate Series' ? "bg-green-400" : "")}>
            <i class="fa-solid fa-cake-candles"></i>
          </span>
        </a>
      </li>
    </ul>
    <a href="/settings" class="mt-auto mx-auto flex items-center justify-center text-green-200 hover:text-green-100 h-10 w-10 focus:outline-none" aria-label="Settings">
      <i class="fa-solid fa-gear"></i>
    </a>
  </div>
</div>
