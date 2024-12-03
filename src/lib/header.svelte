<script lang="ts">
  import { userStore, logout } from '$lib/auth.js';

  export let y: number;
  export let innerHeight: number;

  interface NavTab {
    name: string;
    link: string;
    minRole: number;
  }

  $: tabs = [
    { name: "Order", link: "/order", minRole: 0 },
    { name: "Inventory", link: "/inventory", minRole: 1 },
    { name: "Sales", link: "/sales", minRole: 1 },
  ].filter(tab => {
    console.log('Current user role:', $userStore.role); // Debug log
    return ($userStore.role ?? 0) >= tab.minRole;
  });

  let isDropdownOpen = false;
</script>

<header
  class={"fixed z-[10] top-0 w-full duration-200 px-6 flex items-center justify-between border-b border-solid " +
    (y > 0 ? " py-4 bg-[#d4a373] border-[#cba17f]" : " py-6 bg-[#d4a373] border-[#cba17f]")}
>
  <!-- Header Title -->
  <h1 class="font-medium text-[#faedcd]">
    <b class="font-dynapuff">Laz Bean Cafe</b>
  </h1>
  <!-- Navigation Tabs for larger screens -->
  <div class="sm:flex items-center gap-4 hidden">
    {#each tabs as tab}
      <a href={tab.link} class="duration-200 hover:text-[#faedcd] text-[#faedcd]">
        <p class="font-afacad">{tab.name}</p>
      </a>
    {/each}
    <!-- Connect with me button -->
    <button 
        on:click={async () => {
            try {
                await logout();
            } catch (error) {
                console.error('Logout failed:', error);
            }
        }} 
        class="relative overflow-hidden px-5 py-2 group rounded-full bg-[#faedcd] text-[#d4a373] cursor-pointer"
    >
        <div class="absolute top-0 right-full w-full h-full bg-[#e6ccb2] opacity-20 group-hover:translate-x-full z-0 duration-200" />
        <h4 class="relative z-9 font-afacad">Log out</h4>
    </button>
  </div>
  <!-- Dropdown button for mobile view -->
  <div class="sm:hidden relative">
    <button on:click={() => isDropdownOpen = !isDropdownOpen} class="px-4 py-2 bg-[#faedcd] text-[#d4a373] rounded flex items-center gap-2 hover:text-[#cba17f] duration-200">
      <i class="fas fa-bars"></i>
    </button>
    {#if isDropdownOpen}
      <div class="absolute right-0 mt-2 w-48 bg-[#d4a373] border border-[#cba17f] rounded shadow-lg transition-transform transform origin-top-right duration-200 ease-out scale-100">
        {#each tabs as tab}
          <a href={tab.link} class="block px-4 py-2 text-[#faedcd] hover:text-white duration-200">
            <p class="font-afacad">{tab.name}</p>
          </a>
        {/each}
        <button 
          on:click={logout} 
          class="block w-full text-left px-4 py-2 text-[#faedcd] hover:text-white duration-200 font-afacad cursor-pointer"
        >
          Log out
        </button>
      </div>
    {/if}
  </div>
</header>
