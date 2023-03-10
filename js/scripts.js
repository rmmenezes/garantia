
document.getElementById("print-button").addEventListener("click", function () {
    window.print();
});

// Função para gerar um ID aleatório no formato xxx-xxx-xxx-xxx
function generateID() {
    // Gerar quatro números aleatórios entre 0 e 999
    var num1 = Math.floor(Math.random() * 1000);
    var num2 = Math.floor(Math.random() * 1000);
    var num3 = Math.floor(Math.random() * 1000);
    var num4 = Math.floor(Math.random() * 1000);

    // Adicionar zeros à esquerda se necessário
    num1 = ("000" + num1).slice(-3);
    num2 = ("000" + num2).slice(-3);
    num3 = ("000" + num3).slice(-3);
    num4 = ("000" + num4).slice(-3);

    // Concatenar os números com hífens
    return num1 + "-" + num2 + "-" + num3 + "-" + num4;
}




function previewImage() {
    var preview = document.getElementById('preview');
    var file = document.getElementById('fileInput').files[0];
    var reader = new FileReader();

    reader.addEventListener("load", function () {
        preview.src = reader.result;
        preview.style.width = '100%';
        preview.style.height = '100%';
    }, false);

    if (file) {
        reader.readAsDataURL(file);
    }
};


function applyMask() {
    let cpf = document.getElementById("cpf").value;
    cpf = cpf.replace(/\D/g, "");
    cpf = cpf.replace(/(\d{3})(\d)/, "$1.$2");
    cpf = cpf.replace(/(\d{3})(\d)/, "$1.$2");
    cpf = cpf.replace(/(\d{3})(\d)/, "$1-$2");
    document.getElementById("cpf").value = cpf;
}

function validateCPF() {
    let cpf = document.getElementById("cpf").value;
    cpf = cpf.replace(/[^\d]+/g, "");
    if (cpf === "") return false;

    if (cpf.length !== 11 || cpf === "00000000000" || cpf === "11111111111" || cpf === "22222222222" || cpf === "33333333333" || cpf === "44444444444" || cpf === "55555555555" || cpf === "66666666666" || cpf === "77777777777" || cpf === "88888888888" || cpf === "99999999999") {
        alert("CPF inválido");
        document.getElementById("cpf").value = "";
        return false;
    }

    let sum = 0;
    let rest;
    for (let i = 1; i <= 9; i++) sum = sum + parseInt(cpf.substring(i - 1, i)) * (11 - i);
    rest = (sum * 10) % 11;

    if (rest === 10 || rest === 11) rest = 0;
    if (rest !== parseInt(cpf.substring(9, 10))) {
        alert("CPF inválido");
        document.getElementById("cpf").value = "";
        return false;
    }

    sum = 0;
    for (let i = 1; i <= 10; i++) sum = sum + parseInt(cpf.substring(i - 1, i)) * (12 - i);
    rest = (sum * 10) % 11;

    if (rest === 10 || rest === 11) rest = 0;
    if (rest !== parseInt(cpf.substring(10, 11))) {
        alert("CPF inválido");
        document.getElementById("cpf").value = "";
        return false;
    }
    return true;
}
