<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.clinipet.model.Usuario" %>

<%
    List<Map<String,Object>> productos = (List<Map<String,Object>>) request.getAttribute("productos");
    if (productos == null) productos = new ArrayList<>();
    Usuario usuarioSes = (Usuario) session.getAttribute("usuario");
%>

<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Tienda | CliniPet</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet">
<style>
:root{
    --green:#00a85a;
    --green2:#00d978;
    --dark:#003d25;
    --muted:#64748b;
    --shadow:0 22px 70px rgba(0,60,35,.13);
}
*{box-sizing:border-box}
body{
    margin:0;
    font-family:"Nunito",sans-serif;
    background:linear-gradient(135deg,#fbfffd,#eafff4);
    color:#0f172a;
}
h1,h2,h3{font-family:"Fredoka",sans-serif}
.layout{display:flex;min-height:100vh}

/* ── SIDEBAR (igual que v10 dashboard) ── */
.side{
    width:280px;
    position:fixed;
    left:0;top:0;
    min-height:100vh;
    background:linear-gradient(180deg,#00452a,#00371f);
    color:white;
    padding:28px 22px;
    z-index:100;
}
.brand{display:flex;gap:12px;align-items:center;margin-bottom:30px}
.brand-icon{
    width:58px;height:58px;
    border-radius:20px;
    background:white;color:#00a85a;
    display:grid;place-items:center;font-size:2rem;
}
.navx{display:grid;gap:10px}
.navx a{
    color:#eafff4;text-decoration:none;
    padding:14px 16px;border-radius:15px;
    font-weight:900;display:flex;gap:10px;align-items:center;
    transition:.2s;
}
.navx a:hover,.navx a.active{background:rgba(0,200,117,.28)}

/* ── MAIN LAYOUT ── */
.main{
    margin-left:280px;
    width:calc(100% - 280px);
    padding:32px;
    display:grid;
    grid-template-columns:1fr 370px;
    gap:24px;
    align-items:start;
}
@media(max-width:1100px){.main{grid-template-columns:1fr}}
@media(max-width:900px){
    .layout{display:block}
    .side{position:relative;width:100%;min-height:auto}
    .main{margin-left:0;width:100%;padding:20px}
}

/* ── TOP BAR ── */
.topbar{
    display:flex;justify-content:space-between;align-items:center;
    margin-bottom:0;flex-wrap:wrap;gap:12px;
    grid-column:1/-1;
}
.title{font-size:2.2rem;color:#063823;margin:0}
.btnx{
    border:0;border-radius:14px;
    padding:12px 18px;font-weight:900;
    text-decoration:none;
    display:inline-flex;align-items:center;gap:8px;
    cursor:pointer;font-family:"Nunito",sans-serif;font-size:1rem;
}
.btn-green{background:linear-gradient(135deg,var(--green),var(--green2));color:white}
.btn-green:hover{color:white;transform:translateY(-2px)}
.btn-green:disabled{background:#ccc;cursor:not-allowed;transform:none}
.btn-soft{background:white;color:#003d25;box-shadow:var(--shadow)}
.btn-soft:hover{color:#003d25}

/* ── PANEL (igual que v10 dashboard) ── */
.panel{
    background:white;
    border-radius:26px;
    box-shadow:var(--shadow);
    overflow:hidden;
}
.panel-head{
    padding:20px 24px;
    border-bottom:1px solid #dbeee5;
    display:flex;justify-content:space-between;align-items:center;gap:12px;
}
.panel-title{margin:0;color:#063823;font-family:"Fredoka",sans-serif;font-size:1.3rem}
.panel-body{padding:22px}

/* ── PRODUCTS GRID ── */
.products-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(210px,1fr));gap:18px}
.product-card{
    background:#f8fffb;
    border-radius:20px;
    overflow:hidden;
    border:1.5px solid #dbeee5;
    transition:.2s;
}
.product-card:hover{transform:translateY(-3px);box-shadow:0 12px 35px rgba(0,60,35,.13)}
.product-img{
    height:150px;
    background-size:cover;background-position:center;
    background-color:#e8f5ee;
}
.product-info{padding:14px}
.product-name{font-weight:900;font-size:.95rem;color:#063823;margin:0 0 2px}
.product-cat{color:var(--muted);font-size:.8rem;font-weight:700;margin:0 0 10px}
.price{color:var(--green);font-size:1.2rem;font-weight:900}

/* ── STOCK BADGES ── */
.badge-stock{
    font-size:.75rem;font-weight:800;
    background:#dcfff0;color:#007f4f;
    border-radius:999px;padding:4px 10px;
    display:inline-flex;align-items:center;gap:4px;
}
.badge-nostock{background:#fff1f2;color:#be123c}

/* ── QTY CONTROL ── */
.qty-control{
    display:flex;align-items:center;gap:6px;
    background:#f0fdf4;border-radius:12px;padding:4px 8px;
}
.qty-btn{
    width:28px;height:28px;border:0;
    border-radius:8px;background:white;color:#003d25;
    font-weight:900;font-size:1.1rem;cursor:pointer;
    display:grid;place-items:center;
    box-shadow:0 2px 6px rgba(0,0,0,.08);
}
.qty-val{font-weight:900;min-width:22px;text-align:center;color:#003d25}

/* ── CART PANEL ── */
.cart-panel{
    background:white;
    border-radius:26px;
    box-shadow:var(--shadow);
    overflow:hidden;
    position:sticky;top:24px;
}
.cart-head{
    background:linear-gradient(135deg,#003d25,#00a85a);
    color:white;padding:20px 22px;
    display:flex;align-items:center;gap:12px;
}
.cart-head-title{font-family:"Fredoka",sans-serif;font-size:1.4rem;margin:0;flex:1}
.cart-badge{
    background:white;color:#003d25;
    border-radius:999px;
    min-width:26px;height:26px;
    font-size:.85rem;display:grid;place-items:center;font-weight:900;
    padding:0 6px;
}
.cart-body{padding:18px}
.cart-empty{text-align:center;padding:32px 16px;color:var(--muted)}
.cart-item{
    display:flex;gap:12px;align-items:center;
    padding:12px 0;border-bottom:1.5px solid #eafff4;
}
.cart-item-img{
    width:52px;height:52px;border-radius:12px;
    background-size:cover;background-position:center;
    background-color:#f1f5f9;flex-shrink:0;
}
.cart-item-info{flex:1;min-width:0}
.cart-item-name{font-weight:800;font-size:.88rem;color:#0f172a;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.cart-item-price{color:var(--green);font-weight:900;font-size:.85rem}
.cart-item-remove{
    background:#fff1f2;border:0;border-radius:8px;
    width:28px;height:28px;color:#be123c;cursor:pointer;
    display:grid;place-items:center;flex-shrink:0;
}
.cart-item-qty{display:flex;align-items:center;gap:5px;margin-top:4px}
.cqty-btn{
    width:22px;height:22px;border:0;border-radius:6px;
    background:#f0fdf4;color:#003d25;font-weight:900;
    cursor:pointer;display:grid;place-items:center;font-size:.9rem;
}
.cqty-val{font-weight:900;min-width:18px;text-align:center;font-size:.88rem}
.cart-total{background:#f0fdf4;border-radius:16px;padding:14px;margin-top:14px}
.cart-total-row{display:flex;justify-content:space-between;font-weight:800;font-size:1rem}
.cart-total-price{color:var(--green);font-size:1.35rem;font-weight:900}
.btn-checkout{
    width:100%;border:0;border-radius:16px;
    background:linear-gradient(135deg,var(--green),var(--green2));
    color:white;padding:15px;font-weight:900;font-size:1rem;
    cursor:pointer;margin-top:14px;
    display:flex;align-items:center;justify-content:center;gap:10px;
    transition:.2s;font-family:"Nunito",sans-serif;
}
.btn-checkout:hover{transform:translateY(-3px)}
.btn-checkout:disabled{background:#ccc;cursor:not-allowed;transform:none}
.btn-clear-cart{
    width:100%;border:1.5px solid #fecdd3;border-radius:12px;
    background:#fff1f2;color:#be123c;padding:10px;
    font-weight:900;cursor:pointer;margin-top:8px;
    transition:.2s;font-family:"Nunito",sans-serif;
}
.btn-clear-cart:hover{background:#ffe4e6}

/* ── ALERTS ── */
.alert-msg{
    padding:14px 18px;border-radius:16px;
    font-weight:800;grid-column:1/-1;
}
.alert-ok{background:#dcfff0;color:#007f4f;border:1.5px solid #bbf7d0}
.alert-err{background:#fff1f2;color:#be123c;border:1.5px solid #fecdd3}

/* ── MODAL ── */
.modal-overlay{
    display:none;position:fixed;inset:0;
    background:rgba(0,40,20,.55);z-index:9999;
    align-items:center;justify-content:center;
}
.modal-overlay.open{display:flex}
.modal-box{
    background:white;border-radius:28px;
    max-width:500px;width:90%;
    box-shadow:0 30px 80px rgba(0,60,35,.25);
    overflow:hidden;
}
.modal-box-head{
    background:linear-gradient(135deg,#003d25,#00a85a);
    color:white;padding:22px 26px;
    display:flex;align-items:center;gap:14px;
}
.modal-box-head h2{margin:0;color:white;font-family:"Fredoka",sans-serif;font-size:1.6rem}
.modal-box-body{padding:26px}
.modal-items{
    background:#f8fffb;border-radius:16px;
    padding:16px;margin:16px 0;
    max-height:200px;overflow-y:auto;
}
.modal-item-row{
    display:flex;justify-content:space-between;
    padding:7px 0;border-bottom:1px solid #eafff4;
    font-weight:700;font-size:.9rem;
}
.modal-total{font-size:1.2rem;font-weight:900;color:var(--green);margin:10px 0}
.modal-btns{display:flex;gap:12px;justify-content:flex-end;margin-top:20px}
.modal-confirm{
    border:0;border-radius:14px;
    background:linear-gradient(135deg,var(--green),var(--green2));
    color:white;padding:13px 26px;
    font-weight:900;cursor:pointer;font-size:1rem;
    font-family:"Nunito",sans-serif;
}
.modal-cancel{
    border:1.5px solid #ddd;border-radius:14px;
    background:white;color:#003d25;
    padding:13px 26px;font-weight:900;
    cursor:pointer;font-size:1rem;
    font-family:"Nunito",sans-serif;
}

/* ── CART BUTTON ANIMATION ── */
.cp-cart-icon{
  display:inline-block;
  transition:transform .3s cubic-bezier(.34,1.56,.64,1);
}
.btnx.btn-green:hover .cp-cart-icon{
  transform:translateX(3px) scale(1.25) rotate(-8deg);
}
@keyframes cpCartBounce{
  0%{transform:scale(1)}
  30%{transform:scale(.75) translateY(-4px)}
  60%{transform:scale(1.2) translateY(2px)}
  80%{transform:scale(.95)}
  100%{transform:scale(1)}
}
@keyframes cpCartShake{
  0%,100%{transform:rotate(0)}
  20%{transform:rotate(-18deg)}
  40%{transform:rotate(14deg)}
  60%{transform:rotate(-10deg)}
  80%{transform:rotate(6deg)}
}
.btn-green.adding .cp-cart-icon{
  animation:cpCartShake .4s ease;
}
.btn-green.added-state{
  background:linear-gradient(135deg,#059669,#34d399)!important;
}
.btn-green.added-state i{
  animation:cpCartBounce .5s cubic-bezier(.34,1.56,.64,1) both;
}
.especie-tab {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 7px 16px;
  border-radius: 50px;
  border: 2px solid #b7e9d0;
  background: white;
  color: #00783d;
  font-weight: 700;
  font-size: .88rem;
  cursor: pointer;
  transition: all .18s;
}
.especie-tab:hover {
  background: #edfff5;
  border-color: #00a85a;
}
.especie-tab.active {
  background: linear-gradient(135deg, #00783d, #00c97a);
  color: white;
  border-color: transparent;
  box-shadow: 0 4px 14px rgba(0,168,90,.25);
}
</style>
</head>

<body>
<div class="layout">
    <!-- SIDEBAR (igual que v10 dashboard) -->
    <aside class="side">
        <div class="brand">
            <span class="brand-icon"><i class="ti ti-paw"></i></span>
            <div>
                <h2 class="mb-0 text-white" style="font-family:'Fredoka',sans-serif;font-size:1.6rem;margin:0">CliniPet</h2>
                <small style="color:#dfffee;font-weight:800">Panel cliente</small>
            </div>
        </div>
        <nav class="navx">
            <a href="${pageContext.request.contextPath}/cliente/dashboard">
                <i class="ti ti-home"></i> Mi panel
            </a>
            <a href="${pageContext.request.contextPath}/citas/nueva">
                <i class="ti ti-calendar-plus"></i> Agendar cita
            </a>
            <a class="active" href="${pageContext.request.contextPath}/cliente/comprar">
                <i class="ti ti-shopping-cart"></i> Tienda
            </a>
            <a href="${pageContext.request.contextPath}/">
                <i class="ti ti-world"></i> Ir al inicio
            </a>
            <a href="${pageContext.request.contextPath}/logout" style="margin-top:16px;background:rgba(190,18,60,.25)">
                <i class="ti ti-logout"></i> Cerrar sesión
            </a>
        </nav>
    </aside>

    <main class="main">
        <!-- TOP BAR -->
        <div class="topbar">
            <div>
                <h1 class="title"><i class="ti ti-shopping-bag" style="font-size:2rem;vertical-align:middle;color:#00a85a"></i> Tienda CliniPet</h1>
                <p style="margin:4px 0 0;color:var(--muted);font-weight:700">Agrega productos al carrito y confirma tu pedido.</p>
            </div>
            <a href="${pageContext.request.contextPath}/cliente/dashboard" class="btnx btn-soft">
                <i class="ti ti-arrow-left"></i> Volver al panel
            </a>
        </div>

        <% if(request.getParameter("error") != null){ %>
        <div class="alert-msg alert-err"><i class="ti ti-alert-circle"></i> <%= request.getParameter("error") %></div>
        <% } %>
        <% if(request.getParameter("ok") != null){ %>
        <div class="alert-msg alert-ok"><i class="ti ti-check"></i> ¡Pedido realizado correctamente! Revisa tus compras en el panel.</div>
        <% } %>

        <!-- PRODUCTOS -->
        <div class="panel">
            <div class="panel-head">
                <h2 class="panel-title"><i class="ti ti-package"></i> Productos disponibles</h2>
                <span style="color:var(--muted);font-weight:800;font-size:.9rem"><%= productos.size() %> productos</span>
            </div>
            <div class="panel-body">

                <!-- BARRA DE BÚSQUEDA -->
                <div style="position:relative;margin-bottom:16px">
                    <i class="ti ti-search" style="position:absolute;left:14px;top:50%;transform:translateY(-50%);color:#94a3b8;font-size:1rem;pointer-events:none"></i>
                    <input type="text" id="searchInputCompra" placeholder="Buscar producto por nombre, categoría o especie..."
                           style="width:100%;padding:11px 40px 11px 40px;border-radius:14px;border:1.5px solid #e2e8f0;font-size:.95rem;font-weight:600;outline:none;box-sizing:border-box"
                           oninput="filterCompra()"/>
                    <button id="searchClearCompra" onclick="document.getElementById('searchInputCompra').value='';filterCompra()"
                            style="display:none;position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:#94a3b8;font-size:1.1rem">
                        <i class="ti ti-x"></i>
                    </button>
                </div>

                <!-- FILTROS POR ESPECIE -->
                <div style="display:flex;flex-wrap:wrap;gap:10px;margin-bottom:12px;" id="especieTabs">
                    <button class="especie-tab active" data-especie="todos" onclick="setEspecieFilter(this,'todos')">
                        <i class="ti ti-paw"></i> Todos
                    </button>
                    <button class="especie-tab" data-especie="perro" onclick="setEspecieFilter(this,'perro')">
                        🐶 Canino
                    </button>
                    <button class="especie-tab" data-especie="gato" onclick="setEspecieFilter(this,'gato')">
                        🐱 Felino
                    </button>
                    <button class="especie-tab" data-especie="ave" onclick="setEspecieFilter(this,'ave')">
                        🐦 Aves
                    </button>
                    <button class="especie-tab" data-especie="vaca" onclick="setEspecieFilter(this,'vaca')">
                        🐄 Bovinos
                    </button>
                    <button class="especie-tab" data-especie="caballo" onclick="setEspecieFilter(this,'caballo')">
                        🐴 Equinos
                    </button>
                    <button class="especie-tab" data-especie="perro gato" onclick="setEspecieFilter(this,'perro gato')">
                        <i class="ti ti-heart"></i> Multiespecie
                    </button>
                </div>

                <!-- BADGE MÁS VENDIDOS -->
                <div style="display:flex;align-items:center;gap:10px;margin-bottom:16px;flex-wrap:wrap">
                    <span style="background:#1a3d2b;color:#fff;border-radius:20px;padding:6px 16px;font-weight:800;font-size:.85rem;display:inline-flex;align-items:center;gap:6px">
                        <i class="ti ti-star-filled" style="color:#fbbf24"></i> Más vendidos · Ordenados por popularidad
                    </span>
                    <span id="compra-count" style="color:var(--muted);font-weight:800;font-size:.88rem"></span>
                </div>

                <div class="products-grid" id="productGrid">
                <% for(Map<String,Object> p : productos){
                    String img = p.get("imagen_url") == null ? "" : String.valueOf(p.get("imagen_url"));
                    if(img.trim().isEmpty()){
                        img = "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=900&q=80";
                    }
                    int stockP = 0;
                    try { stockP = Integer.parseInt(String.valueOf(p.get("stock"))); } catch(Exception ex){}
                    String idStr = String.valueOf(p.get("id"));
                    String nombreStr = String.valueOf(p.get("nombre"));
                    String precioStr = String.valueOf(p.get("precio"));
                    String catStr = p.get("categoria") != null ? String.valueOf(p.get("categoria")) : "";
                    String espStr = p.get("especie") != null ? String.valueOf(p.get("especie")) : "";
                %>
                <div class="product-card" data-especie="<%= espStr.toLowerCase() %>" data-nombre="<%= nombreStr.toLowerCase() %>" data-categoria="<%= catStr.toLowerCase() %>">
                    <div class="product-img" style="background-image:url('<%= img %>')"></div>
                    <div class="product-info">
                        <p class="product-name"><%= nombreStr %></p>
                        <p class="product-cat"><%= catStr %><% if(!espStr.isEmpty()){ %> · <%= espStr %><% } %></p>
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
                            <span class="price">$<%= precioStr %></span>
                            <% if(stockP > 0){ %>
                            <span class="badge-stock"><i class="ti ti-package"></i> <%= stockP %> disp.</span>
                            <% } else { %>
                            <span class="badge-stock badge-nostock">Sin stock</span>
                            <% } %>
                        </div>
                        <% if(stockP > 0){ %>
                        <div class="add-row" style="display:flex;align-items:center;gap:10px;flex-wrap:wrap">
                            <div class="qty-control">
                                <button class="qty-btn" onclick="changeQty(this,-1)">−</button>
                                <span class="qty-val">1</span>
                                <button class="qty-btn" onclick="changeQty(this,1)">+</button>
                            </div>
                            <button class="btnx btn-green" style="padding:9px 14px;font-size:.88rem;flex:1;justify-content:center"
                                onclick="addToCart(this)"
                                data-id="<%= idStr %>"
                                data-nombre="<%= nombreStr %>"
                                data-precio="<%= precioStr %>"
                                data-img="<%= img %>"
                                data-stock="<%= stockP %>">
                                <i class="ti ti-shopping-cart-plus cp-cart-icon"></i>
                            </button>
                        </div>
                        <% } else { %>
                        <button class="btnx" style="background:#f1f5f9;color:#94a3b8;cursor:not-allowed;width:100%;justify-content:center;font-size:.88rem" disabled>
                            <i class="ti ti-ban"></i> Sin stock
                        </button>
                        <% } %>
                    </div>
                </div>
                <% } %>
                <% if(productos.isEmpty()){ %>
                <div style="text-align:center;padding:48px;grid-column:1/-1;color:var(--muted)">
                    <i class="ti ti-package-off" style="font-size:3rem"></i>
                    <h3 style="color:var(--muted)">No hay productos disponibles</h3>
                </div>
                <% } %>
                <div id="no-results-compra" style="display:none;text-align:center;padding:48px;grid-column:1/-1;color:var(--muted)">
                    <i class="ti ti-search-off" style="font-size:3rem"></i>
                    <h3 style="color:var(--muted)">Sin productos para esta especie</h3>
                </div>
                </div>
            </div>
        </div>

        <!-- CARRITO -->
        <div class="cart-panel" id="cartPanel">
            <div class="cart-head">
                <i class="ti ti-shopping-cart" style="font-size:1.5rem"></i>
                <h2 class="cart-head-title">Carrito</h2>
                <span class="cart-badge" id="cartCount">0</span>
            </div>
            <div class="cart-body">
                <div id="cartEmpty" class="cart-empty">
                    <i class="ti ti-shopping-cart-off" style="font-size:2.5rem;color:#cbd5e1"></i>
                    <p style="margin:10px 0 0;font-weight:700">Tu carrito está vacío.<br>Agrega productos.</p>
                </div>
                <div id="cartItems" style="display:none"></div>
                <div id="cartFooter" style="display:none">
                    <div class="cart-total">
                        <div class="cart-total-row">
                            <span>Total (<span id="cartTotalQty">0</span> items)</span>
                            <span class="cart-total-price">$<span id="cartTotalPrice">0</span></span>
                        </div>
                    </div>
                    <button class="btn-checkout" id="btnCheckout" onclick="openModal()">
                        <i class="ti ti-check"></i> Confirmar pedido
                    </button>
                    <button class="btn-clear-cart" onclick="clearCart()">
                        <i class="ti ti-trash"></i> Vaciar carrito
                    </button>
                </div>
            </div>
        </div>

    </main>
</div>

<!-- MODAL CONFIRMACIÓN -->
<div class="modal-overlay" id="confirmModal">
    <div class="modal-box">
        <div class="modal-box-head">
            <i class="ti ti-shopping-bag" style="font-size:1.8rem"></i>
            <h2>Confirmar pedido</h2>
        </div>
        <div class="modal-box-body">
            <p style="color:var(--muted);font-weight:700;margin:0 0 4px">Revisa tu pedido antes de confirmar:</p>
            <div class="modal-items" id="modalItemsList"></div>
            <div class="modal-total">Total: $<span id="modalTotal">0</span></div>
            <p style="font-size:.85rem;color:var(--muted);font-weight:700;margin:0">Al confirmar, se enviará una notificación por WhatsApp al administrador.</p>
            <div class="modal-btns">
                <button class="modal-cancel" onclick="closeModal()"><i class="ti ti-x"></i> Cancelar</button>
                <button class="modal-confirm" id="btnConfirm" onclick="submitOrder()"><i class="ti ti-check"></i> Confirmar</button>
            </div>
        </div>
    </div>
</div>

<!-- Formulario oculto para envío -->
<form id="orderForm" method="post" action="${pageContext.request.contextPath}/comprar-carrito" style="display:none">
    <input type="hidden" name="items" id="formItems">
    <input type="hidden" name="redirect" value="tienda">
</form>

<script>
// ────── CARRITO STATE ──────
let cart = {}; // { id: {nombre, precio, img, qty, stock} }

function fmt(n){ return Number(n).toLocaleString('es-CO'); }

function changeQty(btn, delta){
    const ctrl = btn.closest('.qty-control');
    const span = ctrl.querySelector('.qty-val');
    let v = parseInt(span.textContent) + delta;
    if(v < 1) v = 1;
    if(v > 99) v = 99;
    span.textContent = v;
}

function addToCart(btn){
    const row = btn.closest('.add-row');
    const ctrl = row ? row.querySelector('.qty-control') : null;
    const qty = ctrl ? parseInt(ctrl.querySelector('.qty-val').textContent) : 1;
    const id = btn.dataset.id;
    const nombre = btn.dataset.nombre;
    const precio = parseFloat(btn.dataset.precio);
    const img = btn.dataset.img;
    const stock = parseInt(btn.dataset.stock) || 99;

    if(cart[id]){
        cart[id].qty = Math.min(cart[id].qty + qty, stock);
    } else {
        cart[id] = {nombre, precio, img, qty, stock};
    }
    renderCart();
    // Feedback visual
    btn.classList.add('adding');
    setTimeout(function(){
      btn.classList.remove('adding');
      btn.innerHTML = '<i class="ti ti-check"></i>';
      btn.classList.add('added-state');
      btn.style.background = '';
    }, 180);
    setTimeout(()=>{
        btn.innerHTML = '<i class="ti ti-shopping-cart-plus cp-cart-icon"></i>';
        btn.style.background = 'linear-gradient(135deg,var(--green),var(--green2))';
    }, 1200);
}

function removeFromCart(id){
    delete cart[id];
    renderCart();
}

function changeCartQty(id, delta){
    if(!cart[id]) return;
    cart[id].qty = Math.max(1, Math.min(cart[id].qty + delta, cart[id].stock));
    renderCart();
}

function clearCart(){
    cart = {};
    renderCart();
}

function renderCart(){
    const keys = Object.keys(cart);
    const countEl = document.getElementById('cartCount');
    const emptyEl = document.getElementById('cartEmpty');
    const itemsEl = document.getElementById('cartItems');
    const footerEl = document.getElementById('cartFooter');

    let totalQty = 0;
    let totalPrice = 0;

    keys.forEach(id => {
        totalQty += cart[id].qty;
        totalPrice += cart[id].qty * cart[id].precio;
    });

    countEl.textContent = totalQty;

    if(keys.length === 0){
        emptyEl.style.display = '';
        itemsEl.style.display = 'none';
        footerEl.style.display = 'none';
        return;
    }

    emptyEl.style.display = 'none';
    itemsEl.style.display = '';
    footerEl.style.display = '';

    let html = '';

    keys.forEach(id => {
        const item = cart[id];

        html += `
        <div class="cart-item">
            <div class="cart-item-img" style="background-image:url('${item.img}')"></div>

            <div class="cart-item-info">
                <div class="cart-item-name">${item.nombre}</div>

                <div class="cart-item-price">
                    $\${fmt(item.precio * item.qty)}
                </div>

                <div class="cart-item-qty">
                    <button class="cqty-btn" onclick="changeCartQty('${id}',-1)">−</button>
                    <span class="cqty-val">${item.qty}</span>
                    <button class="cqty-btn" onclick="changeCartQty('${id}',1)">+</button>
                </div>
            </div>

            <button class="cart-item-remove"
                    onclick="removeFromCart('${id}')">
                <i class="ti ti-x"></i>
            </button>
        </div>`;
    });

    itemsEl.innerHTML = html;

    document.getElementById('cartTotalQty').textContent = totalQty;
    document.getElementById('cartTotalPrice').textContent = fmt(totalPrice);
}

function openModal(){
    const keys = Object.keys(cart);
    if(keys.length === 0){ alert('El carrito está vacío'); return; }
    let html = '';
    let total = 0;
    keys.forEach(id => {
        const item = cart[id];
        const sub = item.precio * item.qty;
        total += sub;
       html += '<div class="modal-item-row"><span>' + item.nombre + ' x' + item.qty +
        '</span><span>$' + fmt(sub) + '</span></div>';
    });
    document.getElementById('modalItemsList').innerHTML = html;
    document.getElementById('modalTotal').textContent = fmt(total);
    document.getElementById('confirmModal').classList.add('open');
}
function closeModal(){ document.getElementById('confirmModal').classList.remove('open'); }

function submitOrder(){
    document.getElementById('btnConfirm').disabled = true;
    document.getElementById('btnConfirm').innerHTML = '<i class="ti ti-loader"></i> Procesando...';
    document.getElementById('formItems').value = JSON.stringify(cart);
    document.getElementById('orderForm').submit();
}

// Cerrar modal al click fuera
document.getElementById('confirmModal').addEventListener('click', function(e){
    if(e.target === this) closeModal();
});

// ── FILTRO POR ESPECIE ──────────────────────────────────────
let activeEspecieCompra = 'todos';

function setEspecieFilter(btn, especie) {
    activeEspecieCompra = especie;
    document.querySelectorAll('#especieTabs .especie-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    filterCompra();
}

function filterCompra() {
    const q = (document.getElementById('searchInputCompra').value || '').toLowerCase().trim();
    const clearBtn = document.getElementById('searchClearCompra');
    if (clearBtn) clearBtn.style.display = q ? 'inline' : 'none';
    const cards = document.querySelectorAll('#productGrid .product-card');
    let visible = 0;
    cards.forEach(card => {
        const esp    = card.dataset.especie   || '';
        const nombre = card.dataset.nombre    || '';
        const cat    = card.dataset.categoria || '';
        const matchEsp    = activeEspecieCompra === 'todos' || esp.includes(activeEspecieCompra);
        const matchSearch = !q || nombre.includes(q) || esp.includes(q) || cat.includes(q);
        const match = matchEsp && matchSearch;
        card.style.display = match ? '' : 'none';
        if (match) visible++;
    });
    const noRes = document.getElementById('no-results-compra');
    if (noRes) noRes.style.display = (visible === 0) ? 'block' : 'none';
    const cnt = document.getElementById('compra-count');
    if (cnt) cnt.textContent = (q || activeEspecieCompra !== 'todos') ? (visible + ' producto' + (visible !== 1 ? 's' : '')) : '';
}
</script>
<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
</body>
</html>