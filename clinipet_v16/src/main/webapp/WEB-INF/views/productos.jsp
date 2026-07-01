<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>CliniPet | Agregar Producto</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>

    <style>
        body {
            background: linear-gradient(135deg, #eef8ff, #effaf5);
        }

        .product-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 40px 0;
        }

        .form-card {
            border-radius: 28px;
            border: 0;
            box-shadow: 0 30px 80px rgba(15, 47, 90, .15);
        }

        .header-box {
            background: linear-gradient(135deg, #1268e3, #14b889);
            color: white;
            border-radius: 28px 28px 0 0;
            padding: 30px;
        }

        .btn-main {
            background: linear-gradient(135deg, #1268e3, #14b889);
            border: 0;
            color: white;
            font-weight: 700;
            border-radius: 14px;
        }

        .btn-main:hover {
            color: white;
        }
    </style>
</head>

<body>

<div class="product-page">
    <div class="container">
        <div class="card form-card">

            <div class="header-box">
                <h1 class="mb-1">
                    <i class="ti ti-package"></i> Agregar producto
                </h1>
                <p class="mb-0 opacity-75">Registra productos para la tienda veterinaria CliniPet</p>
            </div>

            <div class="card-body p-4 p-md-5">

                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success">
                        <%= request.getAttribute("success") %>
                    </div>
                <% } %>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/productos" method="post">

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Código</label>
                            <input class="form-control" name="codigo" placeholder="Ej: PER007" required>
                        </div>

                        <div class="col-md-8 mb-3">
                            <label class="form-label">Nombre del producto</label>
                            <input class="form-control" name="nombre" placeholder="Ej: Concentrado Premium" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Categoría</label>
                            <select class="form-select" name="categoria" required>
                                <option value="comida">Comida</option>
                                <option value="juguetes">Juguetes</option>
                                <option value="aseo">Aseo</option>
                                <option value="salud">Salud</option>
                                <option value="accesorios">Accesorios</option>
                            </select>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label">Especie</label>
                            <select class="form-select" name="especie" required>
                                <option value="perro">Perro</option>
                                <option value="gato">Gato</option>
                                <option value="caballo">Caballo</option>
                                <option value="vaca">Vaca</option>
                                <option value="ave">Ave</option>
                                <option value="perro gato">Perro y gato</option>
                            </select>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label">Fecha vencimiento</label>
                            <input class="form-control" type="date" name="fecha_vencimiento" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Precio</label>
                            <input class="form-control" type="number" name="precio" placeholder="Ej: 85000" required>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label">Stock</label>
                            <input class="form-control" type="number" name="stock" placeholder="Ej: 20" required>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label">Stock mínimo</label>
                            <input class="form-control" type="number" name="stock_minimo" placeholder="Ej: 5" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Descripción</label>
                        <textarea class="form-control" name="descripcion" rows="3" placeholder="Descripción del producto"></textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">URL de imagen</label>
                        <input class="form-control" name="imagen_url" placeholder="https://...">
                    </div>

                    <div class="d-flex gap-2">
                        <button class="btn btn-main" type="submit">
                            <i class="ti ti-device-floppy"></i> Guardar producto
                        </button>

                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary">
                            <i class="ti ti-arrow-left"></i> Volver al dashboard
                        </a>

                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                            <i class="ti ti-home"></i> Ver tienda
                        </a>
                    </div>

                </form>

            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
</body>
</html>