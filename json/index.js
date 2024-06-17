const AWS = require("aws-sdk");
const str = require("querystring");

const Client = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });
const s3 = new AWS.S3();
var filecontent = "[";
var finalstr = "";
const bucketName = "exportdynamojson";
const filePath = "dynamodb_table.json";

exports.handler = (event, context, callback) => {
  var parameter = {
    TableName: "dbapp",    
    Item: "item",
    Limit: 100,
  };

  Client.scan(parameter, function (err, data) {
    if (err) callback(err, null);
    else {
      var count = Object.keys(data.Items);
      for (var i = count.length - 1; i >= 0; i--) {
        console.info("\ncertificado: " + data.Items[i]["certificado"] + "\n");
        console.info("\ndescripcion: " + data.Items[i]["descripcion"] + "\n");
        console.info("\ncursos: " + data.Items[i]["cursos"] + "\n");
        console.info("\nfname: " + data.Items[i]["fname"] + "\n");
        console.info("\nlenguajes: " + data.Items[i]["lenguajes"] + "\n");
        console.info("\ntel: " + data.Items[i]["tel"] + "\n");
        console.info("\nAcademica: " + data.Items[i]["Academica"] + "\n");
        console.info("\nid: " + data.Items[i]["id"] + "\n");
        console.info("\nlname: " + data.Items[i]["lname"] + "\n");
        console.info("\nnumdoc: " + data.Items[i]["numdoc"] + "\n");
        console.info("\nemail: " + data.Items[i]["email"] + "\n");
        console.info("\nfecha: " + data.Items[i]["fecha"] + "\n");
        
        filecontent +=
          '{\n  "id":"' + 
          data.Items[i]["id"] +
          '", \n  "fecha":"' +
          data.Items[i]["fecha"] +
          '", \n  "numdoc":"' +
          data.Items[i]["numdoc"] +
          '", \n  "lname":"' +
          data.Items[i]["lname"] +
          '", \n  "fname":"' +
          data.Items[i]["fname"] +
          '", \n  "tel":"' +
          data.Items[i]["tel"] +
          '", \n  "email":"' +
          data.Items[i]["email"] +
          '", \n  "certificado":"' +
          data.Items[i]["certificado"] +
          '", \n  "descripcion":"' +
          data.Items[i]["descripcion"] +
          '", \n  "Academica":"' +
          data.Items[i]["Academica"] +
          '", \n  "cursos":"' +
          data.Items[i]["cursos"] +
          '", \n  "lenguajes":"' +
          data.Items[i]["lenguajes"] +
          '" \n }';
        if (i != 0) {
          filecontent = filecontent + ",";
        }

        console.info("200 : success");
        
      }
      filecontent = filecontent + "]";
      putObjectToS3(bucketName, filePath, filecontent);

      callback(null, "200 : success");
    }
  });
};

function putObjectToS3(bucket, key, data) {
  var s3 = new AWS.S3();
  var params = {
    Bucket: bucket,
    Key: key,
    Body: data,
    ContentType: 'application/json'
    
  };
  s3.putObject(params, function (err, data) {
    if (err) {
      console.log(err, err.stack); // an error occurred
    } else {
      console.info("File" + key + "Created\n" + data); // successful response
    }
  });
}


