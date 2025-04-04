
# 🧩 SAYT Trending Admin Template (Drag & Drop)

## 📁 File Structure

- `index.html`: Main interface layout.
- `styles.css`: Custom styling for drag and drop UI.
- `script.js`: All logic for UI actions (add/edit/remove/move items, preview, confirmation modal, toast, etc.).

## 🚀 How to Use

### 1. Open the Interface

Simply open `index.html` in your browser to start using the tool.

### 2. Main Features

#### ✅ Add Trending Item

Click **"Add Item"** → enter `keyword` and `url`.

#### 📦 Drag & Drop

- Use the ☰ icon to drag and reorder items.
- The updated order is reflected instantly in the **Preview** section.

#### 💾 Save Changes

- After editing, click **"Save Changes"**.
- Confirm the action in the modal popup.
- Data is stored in `localStorage`.

#### 🔁 Toggle Override

- Use the switch in the "Override Constructor.IO Feed" section.
- Default is "Enabled" (custom trending list used).

#### 🧪 Preview

- Displays a tag-style live preview of trending items.
- Updates in real-time as you edit.

### 3. Limitations

- Maximum **5 items** allowed.
- All fields (`keyword`, `url`) must be filled before saving.

---

## 🔧 Tech Stack

- 💨 **TailwindCSS** – responsive and clean UI.
- 📦 **SortableJS** – drag and drop interactions.
- 🧠 **localStorage** – data persistence in browser.
- 🎯 **Vanilla JavaScript** – no frameworks required.

---

## 📄 Code Overview

### HTML: `index.html`  
```html
<!-- Includes Tailwind, SortableJS, FontAwesome, and dynamic areas -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SAYT What's Trending Admin | SwimOutlet</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            "swim-blue": {
              DEFAULT: "#0047AB",
              light: "#4A7CC2",
              dark: "#003380",
            }
          },
          animation: {
            'pulse-fast': 'pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite',
          }
        }
      }
    }
  </script>
  <link rel="stylesheet" href="styles.css">
  <style>
    /* Global style to prevent text selection during drag */
    body.dragging {
      user-select: none;
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
      cursor: grabbing !important;
    }
    
    body.dragging * {
      cursor: grabbing !important;
    }

    /* Modal backdrop */
    .modal-backdrop {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 100;
    }

    /* Modal animation */
    .modal-content {
      animation: modalFadeIn 0.2s ease-out;
    }

    @keyframes modalFadeIn {
      from {
        opacity: 0;
        transform: translateY(-20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Loading animation */
    .skeleton-loader {
      background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
      background-size: 200% 100%;
      animation: loading 1.5s infinite;
    }

    @keyframes loading {
      0% {
        background-position: 200% 0;
      }
      100% {
        background-position: -200% 0;
      }
    }
  </style>
</head>
<body class="min-h-screen p-6 md:p-10 bg-gray-50">
  <div class="max-w-5xl mx-auto">
    <h1 class="text-2xl md:text-3xl font-bold text-blue-800 mb-2">SAYT What&apos;s Trending</h1>
    <p class="text-gray-600 mb-8">Manage trending search keywords that appear in the global search dropdown</p>

<!-- Add loading overlay for the Override Constructor.IO Feed section -->
<div class="mb-6 p-4 border rounded-md bg-white relative">
  <!-- Loading overlay for override section -->
  <div id="override-loading" class="absolute inset-0 bg-white bg-opacity-80 flex items-center justify-center z-10 hidden">
    <div class="flex flex-col items-center">
      <div class="w-8 h-8 border-3 border-blue-600 border-t-transparent rounded-full animate-spin mb-2"></div>
      <p class="text-blue-600 font-medium text-sm">Loading...</p>
    </div>
  </div>
  
  <div class="flex items-center justify-between">
    <div>
      <h3 class="font-medium">Override Constructor.IO Feed</h3>
      <p class="text-sm text-gray-500" id="override-status">
        Currently using custom trending items defined below
      </p>
    </div>
    <div class="flex items-center space-x-2">
      <label class="inline-flex items-center cursor-pointer">
        <input type="checkbox" id="override-toggle" class="sr-only peer" checked>
        <div class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
        <span class="ml-3 text-sm font-medium" id="toggle-label">Enabled</span>
      </label>
    </div>
  </div>
</div>

    <div class="grid gap-8 md:grid-cols-2">
      <div>
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-semibold">Edit Trending Items</h2>
          <div class="flex gap-2">
            <button id="add-item-btn" class="px-3 py-1 text-sm border rounded-md flex items-center gap-1 hover:bg-gray-50">
              <i class="fas fa-plus text-xs"></i> Add Item
            </button>
            <button id="save-btn" class="px-3 py-1 text-sm bg-blue-600 text-white rounded-md flex items-center gap-1 hover:bg-blue-700">
              <i class="fas fa-save text-xs"></i> Save Changes
            </button>
          </div>
        </div>

        <div class="border rounded-md p-4 bg-white relative">
          <!-- Loading overlay for items -->
          <div id="items-loading" class="absolute inset-0 bg-white bg-opacity-80 flex items-center justify-center z-10 hidden">
            <div class="flex flex-col items-center">
              <div class="w-10 h-10 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mb-2"></div>
              <p class="text-blue-600 font-medium">Loading...</p>
            </div>
          </div>
          
          <div id="trending-items" class="space-y-3">
            <!-- Items will be added here dynamically -->
          </div>
          <div id="empty-state" class="text-center py-6 text-gray-500 hidden">
            No trending items. Click "Add Item" to create one.
          </div>
          
          <!-- Skeleton loaders for items -->
          <div id="skeleton-items" class="space-y-3 hidden">
            <div class="bg-white border rounded-md p-3">
              <div class="flex items-center gap-2 mb-2">
                <div class="w-5 h-5 skeleton-loader rounded"></div>
                <div class="w-16 h-5 skeleton-loader rounded"></div>
                <div class="w-5 h-5 skeleton-loader rounded ml-auto"></div>
              </div>
              <div class="space-y-3">
                <div>
                  <div class="w-16 h-4 skeleton-loader rounded mb-1"></div>
                  <div class="w-full h-10 skeleton-loader rounded"></div>
                </div>
                <div>
                  <div class="w-8 h-4 skeleton-loader rounded mb-1"></div>
                  <div class="w-full h-10 skeleton-loader rounded"></div>
                </div>
              </div>
            </div>
            <div class="bg-white border rounded-md p-3">
              <div class="flex items-center gap-2 mb-2">
                <div class="w-5 h-5 skeleton-loader rounded"></div>
                <div class="w-16 h-5 skeleton-loader rounded"></div>
                <div class="w-5 h-5 skeleton-loader rounded ml-auto"></div>
              </div>
              <div class="space-y-3">
                <div>
                  <div class="w-16 h-4 skeleton-loader rounded mb-1"></div>
                  <div class="w-full h-10 skeleton-loader rounded"></div>
                </div>
                <div>
                  <div class="w-8 h-4 skeleton-loader rounded mb-1"></div>
                  <div class="w-full h-10 skeleton-loader rounded"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div>
        <h2 class="text-xl font-semibold mb-4">Preview</h2>
        <div class="border rounded-md bg-white shadow-sm p-6 relative">
          <!-- Loading overlay for preview -->
          <div id="preview-loading" class="absolute inset-0 bg-white bg-opacity-80 flex items-center justify-center z-10 hidden">
            <div class="flex flex-col items-center">
              <div class="w-10 h-10 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mb-2"></div>
              <p class="text-blue-600 font-medium">Loading preview...</p>
            </div>
          </div>
          
          <div>
            <h3 class="text-lg font-medium mb-3">What&apos;s Trending</h3>
            <div id="constructor-preview" class="bg-gray-50 p-4 rounded-md border border-dashed hidden">
              <div class="text-gray-500 text-center">
                <p class="font-medium">Constructor.IO Feed Active</p>
              </div>
            </div>
            <div id="trending-preview" class="flex flex-wrap gap-2">
              <!-- Preview items will be added here dynamically -->
            </div>
            <div id="preview-empty-state" class="text-gray-400 italic hidden">No trending items to display</div>
            
            <!-- Skeleton loader for preview -->
            <div id="skeleton-preview" class="flex flex-wrap gap-2 hidden">
              <div class="px-4 py-2 rounded-full skeleton-loader w-24 h-8"></div>
              <div class="px-4 py-2 rounded-full skeleton-loader w-32 h-8"></div>
              <div class="px-4 py-2 rounded-full skeleton-loader w-28 h-8"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Toast notification -->
  <div id="toast" class="fixed bottom-4 right-4 bg-white border border-gray-200 rounded-lg shadow-lg p-4 max-w-xs z-50 hidden">
    <div class="flex items-center">
      <div id="toast-icon" class="flex-shrink-0 w-6 h-6 text-green-500 mr-2">
        <i class="fas fa-check-circle"></i>
      </div>
      <div>
        <p id="toast-title" class="font-medium">Success</p>
        <p id="toast-message" class="text-sm text-gray-500">Your changes have been saved.</p>
      </div>
      <button onclick="hideToast()" class="ml-auto text-gray-400 hover:text-gray-500">
        <i class="fas fa-times"></i>
      </button>
    </div>
  </div>

  <!-- Confirmation Modal (hidden by default) -->
  <div id="confirmation-modal" class="modal-backdrop hidden">
    <div class="modal-content bg-white rounded-lg shadow-xl p-6 max-w-md mx-auto">
      <div class="flex items-center mb-4">
        <div class="flex-shrink-0 w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center mr-4">
          <i class="fas fa-question-circle text-blue-600 text-xl"></i>
        </div>
        <h3 class="text-lg font-medium" id="modal-title">Confirm Change</h3>
      </div>
      <div class="mb-6">
        <p id="modal-message">Are you sure you want to change this setting?</p>
      </div>
      <div class="flex justify-end gap-3">
        <button id="modal-cancel" class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50">
          Cancel
        </button>
        <button id="modal-confirm" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
          Confirm
        </button>
      </div>
    </div>
  </div>

  <script src="script.js"></script>
</body>
</html>
```

### JavaScript: `script.js`
```js
// State management
let settings = {
  overrideEnabled: true,
  items: [
    { id: "1", keyword: "Goggles", url: "/goggles" },
    { id: "2", keyword: "Swim cap", url: "/swim-caps" },
    { id: "3", keyword: "Jolyn", url: "/brands/jolyn" },
  ],
}

// Loading state
let isLoading = false

// DOM Elements
const trendingItemsContainer = document.getElementById("trending-items")
const emptyState = document.getElementById("empty-state")
const overrideToggle = document.getElementById("override-toggle")
const overrideStatus = document.getElementById("override-status")
const toggleLabel = document.getElementById("toggle-label")
const addItemBtn = document.getElementById("add-item-btn")
const saveBtn = document.getElementById("save-btn")
const trendingPreview = document.getElementById("trending-preview")
const previewEmptyState = document.getElementById("preview-empty-state")
const constructorPreview = document.getElementById("constructor-preview")
const confirmationModal = document.getElementById("confirmation-modal")
const modalTitle = document.getElementById("modal-title")
const modalMessage = document.getElementById("modal-message")
const modalCancel = document.getElementById("modal-cancel")
const modalConfirm = document.getElementById("modal-confirm")

// Loader elements
const itemsLoading = document.getElementById("items-loading")
const previewLoading = document.getElementById("preview-loading")
const skeletonItems = document.getElementById("skeleton-items")
const skeletonPreview = document.getElementById("skeleton-preview")
const overrideLoading = document.getElementById("override-loading") // Add this line

// Action types for the confirmation modal
const ACTIONS = {
  TOGGLE_OVERRIDE: "toggle_override",
  SAVE_CHANGES: "save_changes",
}

// Current action being confirmed
let currentAction = null

// Initialize the app
document.addEventListener("DOMContentLoaded", () => {
  // Show loading state
  setLoading(true)

  // Simulate API loading delay
  setTimeout(() => {
    // Load saved settings from localStorage if available
    const savedSettings = localStorage.getItem("trendingSettings")
    if (savedSettings) {
      settings = JSON.parse(savedSettings)
      overrideToggle.checked = settings.overrideEnabled
    }

    // Initialize UI
    updateUI()

    // Hide loading state
    setLoading(false)
  }, 1000) // Simulate 1 second loading time

  // Set up event listeners
  overrideToggle.addEventListener("change", handleToggleChange)
  addItemBtn.addEventListener("click", addItem)
  saveBtn.addEventListener("click", handleSaveChanges)
  modalCancel.addEventListener("click", cancelAction)
  modalConfirm.addEventListener("click", confirmAction)
  confirmationModal.addEventListener("click", (e) => {
    if (e.target === confirmationModal) {
      cancelAction()
    }
  })

  // Initialize Sortable for drag and drop
  initSortable()
})

// Set loading state
function setLoading(loading) {
  isLoading = loading

  if (loading) {
    // Show loaders
    itemsLoading.classList.remove("hidden")
    previewLoading.classList.remove("hidden")
    skeletonItems.classList.remove("hidden")
    skeletonPreview.classList.remove("hidden")
    overrideLoading.classList.remove("hidden") // Add this line

    // Hide content
    trendingItemsContainer.classList.add("hidden")
    trendingPreview.classList.add("hidden")

    // Disable buttons
    addItemBtn.disabled = true
    saveBtn.disabled = true
    overrideToggle.disabled = true
  } else {
    // Hide loaders
    itemsLoading.classList.add("hidden")
    previewLoading.classList.add("hidden")
    skeletonItems.classList.add("hidden")
    skeletonPreview.classList.add("hidden")
    overrideLoading.classList.add("hidden") // Add this line

    // Show content
    trendingItemsContainer.classList.remove("hidden")
    trendingPreview.classList.remove("hidden")

    // Enable buttons
    addItemBtn.disabled = false
    saveBtn.disabled = false
    overrideToggle.disabled = false
  }
}

// Variables to store toggle state
let pendingToggleValue = null

// Handle toggle change with confirmation
function handleToggleChange(e) {
  // Store the new value
  pendingToggleValue = overrideToggle.checked

  // Revert the toggle change until confirmed
  overrideToggle.checked = settings.overrideEnabled

  // Set modal content
  if (pendingToggleValue) {
    modalTitle.textContent = "Enable Custom Trending Items"
    modalMessage.textContent = "Are you sure you want to override the Constructor.IO feed with custom trending items?"
  } else {
    modalTitle.textContent = "Disable Custom Trending Items"
    modalMessage.textContent = "Are you sure you want to use the Constructor.IO feed instead of custom trending items?"
  }

  // Set current action
  currentAction = ACTIONS.TOGGLE_OVERRIDE

  // Show the confirmation modal
  confirmationModal.classList.remove("hidden")
}

// Handle save changes with confirmation
function handleSaveChanges() {
  // Validate items if override is enabled
  if (settings.overrideEnabled) {
    const emptyFields = settings.items.some((item) => !item.keyword || !item.url)
    if (emptyFields) {
      showToast("Validation error", "All fields must be filled out before saving.", "error")
      return
    }
  }

  // Set modal content
  modalTitle.textContent = "Save Changes"
  modalMessage.textContent = "Are you sure you want to save your changes to the trending items?"

  // Set current action
  currentAction = ACTIONS.SAVE_CHANGES

  // Show the confirmation modal
  confirmationModal.classList.remove("hidden")
}

// Cancel the current action
function cancelAction() {
  pendingToggleValue = null
  currentAction = null
  confirmationModal.classList.add("hidden")
}

// Confirm the current action
function confirmAction() {
  if (currentAction === ACTIONS.TOGGLE_OVERRIDE && pendingToggleValue !== null) {
    // Show loading state for just the override section
    overrideLoading.classList.remove("hidden")
    overrideToggle.disabled = true

    // Simulate API delay
    setTimeout(() => {
      settings.overrideEnabled = pendingToggleValue
      overrideToggle.checked = pendingToggleValue
      updateToggleUI()
      updatePreview()
      pendingToggleValue = null

      // Hide loading state
      overrideLoading.classList.add("hidden")
      overrideToggle.disabled = false
    }, 800)
  } else if (currentAction === ACTIONS.SAVE_CHANGES) {
    saveChanges()
  }

  currentAction = null
  confirmationModal.classList.add("hidden")
}

// Initialize Sortable.js for drag and drop functionality
function initSortable() {
  if (typeof Sortable !== "undefined") {
    Sortable.create(trendingItemsContainer, {
      animation: 200,
      handle: ".sortable-handle",
      ghostClass: "sortable-ghost",
      chosenClass: "sortable-chosen",
      dragClass: "sortable-drag",
      forceFallback: true,
      fallbackClass: "sortable-fallback",
      fallbackOnBody: true,
      // Prevent text selection during drag
      preventOnFilter: true,
      filter: ".ignore-elements",
      // Disable auto-scrolling which can cause issues
      scrollSensitivity: 0,
      // Add this to prevent text selection during drag
      onStart: () => {
        document.body.classList.add("dragging")
      },
      onEnd: (evt) => {
        document.body.classList.remove("dragging")

        // Update the items array after drag and drop
        const itemElements = Array.from(trendingItemsContainer.children)
        const newItems = []

        itemElements.forEach((element) => {
          const id = element.dataset.id
          const item = settings.items.find((item) => item.id === id)
          if (item) {
            newItems.push(item)
          }
        })

        settings.items = newItems
        updateItemNumbers() // Update item numbers after reordering
        updatePreview()
      },
    })
  } else {
    console.error("SortableJS is not loaded. Make sure to include it in your HTML.")
  }
}

// Add a new function to update item numbers
function updateItemNumbers() {
  const itemElements = Array.from(trendingItemsContainer.children)
  itemElements.forEach((element, index) => {
    const itemNumberEl = element.querySelector(".item-number")
    if (itemNumberEl) {
      itemNumberEl.textContent = `Item ${index + 1}`
    }
  })
}

// Update the entire UI based on current settings
function updateUI() {
  updateToggleUI()
  renderItems()
  updatePreview()
}

// Update the toggle UI based on current settings
function updateToggleUI() {
  if (settings.overrideEnabled) {
    overrideStatus.textContent = "Currently using custom trending items defined below"
    toggleLabel.textContent = "Enabled"
    constructorPreview.classList.add("hidden")
    trendingPreview.classList.remove("hidden")
  } else {
    overrideStatus.textContent = "Currently using Constructor.IO feed trending items"
    toggleLabel.textContent = "Disabled"
    constructorPreview.classList.remove("hidden")
    trendingPreview.classList.add("hidden")
  }
}

// Render all trending items
function renderItems() {
  trendingItemsContainer.innerHTML = ""

  if (settings.items.length === 0) {
    emptyState.classList.remove("hidden")
  } else {
    emptyState.classList.add("hidden")

    settings.items.forEach((item, index) => {
      const itemElement = createItemElement(item, index)
      trendingItemsContainer.appendChild(itemElement)
    })
  }
}

// Create a single item element
function createItemElement(item, index) {
  const itemElement = document.createElement("div")
  itemElement.className = "bg-white border rounded-md p-3"
  itemElement.dataset.id = item.id

  itemElement.innerHTML = `
    <div class="flex items-center gap-2 mb-2">
      <div class="sortable-handle cursor-grab text-gray-400 hover:text-gray-600">
        <i class="fas fa-grip-vertical"></i>
      </div>
      <div class="font-medium item-number">Item ${index + 1}</div>
      <button class="delete-btn ml-auto h-8 w-8 text-gray-500 hover:text-red-500 bg-transparent border-none cursor-pointer">
        <i class="fas fa-trash-alt"></i>
      </button>
    </div>

    <div class="space-y-3">
      <div>
        <label class="text-sm font-medium mb-1 block">Keyword</label>
        <input 
          type="text" 
          class="keyword-input w-full px-3 py-2 border rounded-md" 
          value="${item.keyword}" 
          placeholder="Enter search keyword"
        >
      </div>

      <div>
        <label class="text-sm font-medium mb-1 block">URL</label>
        <input 
          type="text" 
          class="url-input w-full px-3 py-2 border rounded-md" 
          value="${item.url}" 
          placeholder="Enter destination URL"
        >
      </div>
    </div>
  `

  // Add event listeners
  const deleteBtn = itemElement.querySelector(".delete-btn")
  deleteBtn.addEventListener("click", () => removeItem(item.id))

  const keywordInput = itemElement.querySelector(".keyword-input")
  keywordInput.addEventListener("input", (e) => updateItem(item.id, "keyword", e.target.value))

  const urlInput = itemElement.querySelector(".url-input")
  urlInput.addEventListener("input", (e) => updateItem(item.id, "url", e.target.value))

  return itemElement
}

// Add a new item
function addItem() {
  if (settings.items.length >= 5) {
    showToast("Maximum items reached", "You can only have up to 5 trending items.", "error")
    return
  }

  const newItem = { id: Date.now().toString(), keyword: "", url: "" }
  settings.items.push(newItem)

  renderItems()
  updatePreview()
}

// Remove an item
function removeItem(id) {
  settings.items = settings.items.filter((item) => item.id !== id)
  renderItems()
  updatePreview()
}

// Update an item property
function updateItem(id, field, value) {
  settings.items = settings.items.map((item) => (item.id === id ? { ...item, [field]: value } : item))
  updatePreview()
}

// Update the preview section
function updatePreview() {
  if (!settings.overrideEnabled) {
    return
  }

  trendingPreview.innerHTML = ""

  if (settings.items.length === 0) {
    previewEmptyState.classList.remove("hidden")
  } else {
    previewEmptyState.classList.add("hidden")

    settings.items.forEach((item, index) => {
      const previewItem = document.createElement("a")
      previewItem.href = "#"
      previewItem.className = "px-4 py-2 rounded-full border hover:bg-gray-100 transition-colors text-sm"
      previewItem.textContent = item.keyword || `Item ${index + 1}`
      previewItem.addEventListener("click", (e) => e.preventDefault())

      trendingPreview.appendChild(previewItem)
    })
  }
}

// Save changes
function saveChanges() {
  // Show loading state
  setLoading(true)

  // Simulate API call with delay
  setTimeout(() => {
    // In a real implementation, this would be an API call
    localStorage.setItem("trendingSettings", JSON.stringify(settings))

    // Hide loading state
    setLoading(false)

    showToast("Changes saved", "Your trending settings have been updated successfully.", "success")
  }, 1200)
}

// Show toast notification
function showToast(title, message, type = "success") {
  const toast = document.getElementById("toast")
  const toastTitle = document.getElementById("toast-title")
  const toastMessage = document.getElementById("toast-message")
  const toastIcon = document.getElementById("toast-icon")

  toastTitle.textContent = title
  toastMessage.textContent = message

  if (type === "error") {
    toastIcon.innerHTML = '<i class="fas fa-exclamation-circle"></i>'
    toastIcon.className = "flex-shrink-0 w-6 h-6 text-red-500 mr-2"
  } else {
    toastIcon.innerHTML = '<i class="fas fa-check-circle"></i>'
    toastIcon.className = "flex-shrink-0 w-6 h-6 text-green-500 mr-2"
  }

  toast.classList.remove("hidden")

  // Hide toast after 3 seconds
  setTimeout(hideToast, 3000)
}

// Hide toast notification
function hideToast() {
  const toast = document.getElementById("toast")
  toast.classList.add("hidden")
}
```

### CSS: `styles.css`
```css
/* Additional custom styles */
.sortable-ghost {
  opacity: 0.5;
  background-color: #f3f4f6;
  border: 2px dashed #9ca3af;
}

.sortable-chosen {
  background-color: #f9fafb;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.sortable-handle {
  cursor: grab;
}

.sortable-handle:active {
  cursor: grabbing;
}

/* Prevent text selection during drag */
.sortable-fallback,
.sortable-chosen,
.sortable-drag {
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
}

/* Input focus styles */
input:focus {
  outline: 2px solid rgba(59, 130, 246, 0.5);
  outline-offset: -1px;
}
```

---

## 📌 Notes

- All destructive actions prompt a confirmation modal.
- Fully browser-based. No backend needed.
- Settings persist after refresh via `localStorage`.

---
