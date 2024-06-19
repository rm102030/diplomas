// import data from "./exportedData.json" assert { type: "json" };
import data from "https://exportdynamojson.s3.amazonaws.com/dynamodb_table.json" assert { type: "json" };
console.log(data);

// const table =
// [{
//   "certificado": "3158837.jpg",
//   "descripcion": "AWS",
//   "cursos": "aws",
//   "fname": "Ricardo",
//   "lenguajes": "NoAplica",
//   "tel": "3046373519",
//   "Academica": "NoAplica",
//   "id": "92",
//   "lname": "Martinez",
//   "numdoc": "79215140",
//   "email": "ricardomartinezcun%40gmail.com",
//   "fecha": "2024-06-06"
// },{
//   "certificado": "3093487.jpg",
//   "descripcion": "Certificado",
//   "cursos": "NoAplica",
//   "fname": "Carlos",
//   "lenguajes": "NoAplica",
//   "tel": "3046373519",
//   "Academica": "especializacion",
//   "id": "570",
//   "lname": "Martinez",
//   "numdoc": "72345678",
//   "email": "ricardomartinezcun%40gmail.com",
//   "fecha": "2024-06-06"
// },{
//   "certificado": "7210378.jpg",
//   "descripcion": "Diploma+de+Bachiller",
//   "cursos": "NoAplica",
//   "fname": "Juan+",
//   "lenguajes": "NoAplica",
//   "tel": "3046373519",
//   "Academica": "bachiller",
//   "id": "945",
//   "lname": "Mart",
//   "numdoc": "79215140",
//   "email": "ricardomartinezcun%40gmail.com",
//   "fecha": "2024-06-06"
// }]


// const tableHeader = Object.keys(table[0]);
const tableHeader = Object.keys(data[0]);
const search = document.querySelector('.filter-input');
const output = document.querySelector('.output');

window.addEventListener('DOMContentLoaded', loadTable);
search.addEventListener('input', filter);


function loadTable(){
    let temp = `<table> <tr>`;
    tableHeader.forEach( header=> temp+= `<th> ${header.toUpperCase()} </th>`);
    temp+=`<tr>`
    data.forEach(row => {
        temp +=`
        <tr>

          <td>${row.name}</td>
          <td>${row.age}</td>
          <td>${row.occupation}</td>
          <td>${row.city}</td>
          <td>${row.state}</td>
        </tr>
        `
    });

    temp+=`</table>`
    output.innerHTML = temp;
}


function filter(e){
let results;
let temp ="";

results = data.filter( item=>
    item.id.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.fecha.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.numdoc.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.lname.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.fname.toLowerCase().includes(e.target.value.toLowerCase()) ||
    item.tel.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.email.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.certificado.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.descripcion.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.Academica.toLowerCase().includes(e.target.value.toLowerCase()) || 
    item.cursos.toLowerCase().includes(e.target.value.toLowerCase()) ||    
    item.lenguajes.toLowerCase().includes(e.target.value.toLowerCase())
    );
   console.log(results)
    if(results.length>0){
        temp = `<table> <tr>`;
        tableHeader.forEach( header=> temp+= `<th> ${header.toUpperCase()} </th>`);
        temp+=`<tr>`
        results.forEach(row => {
            temp +=`
            <tr>
              <td>${row.id}</td>
              <td>${row.fecha}</td>
              <td>${row.numdoc}</td>
              <td>${row.lname}</td>
              <td>${row.fname}</td>
              <td>${row.tel}</td>
              <td>${row.email}</td>
              <td>${row.certificado}</td>
              <td>${row.descripcion}</td>
              <td>${row.Academica}</td>
              <td>${row.cursos}</td>
              <td>${row.lenguajes}</td>             
            </tr>
            `
        });
        temp+=`</table>`  
    }else{
        temp =`<div class="no-item">Item No Encontrado!</div>`
    }

    output.innerHTML=temp;
}
