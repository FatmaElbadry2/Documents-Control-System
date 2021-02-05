from flask import Flask, request,jsonify
from flask_mysqldb import MySQL

app = Flask(__name__)
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Fatooma'
app.config['MYSQL_DB'] = 'documents'

mysql = MySQL(app)


@app.route('/')
def Index():
    cur = mysql.connection.cursor()
    cur.execute("SELECT  * FROM employee")
    data = cur.fetchall()
    employees=[]
    for i in range(len(employees)):
            id = employees[i][0]
            f_name = employees[i][1]
            l_name = employees[i][2]
            dataDict = {
                "id": id,
                "f_name": f_name,
                "l_name": l_name
            }
            employees.append(dataDict)

    cur.close()
    return jsonify(dataDict)





@app.route('/insert/', methods=['POST'])
def insert():
    body = request.json
    f_name = body['f_name']
    l_name = body['l_name']
    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO employee (l_name, f_name) VALUES (%s, %s, %s)", (l_name, f_name))
    mysql.connection.commit()
    cur.close()
    return jsonify({
        'status': 'Success',
        'f_name': f_name,
        'l_age': l_name
    })


@app.route('/edit/<string:id>', methods=['PUT'])
def edit():
    body = request.json
    f_name = body['f_name']
    l_name = body['l_name']

    cur = mysql.connection.cursor()
    cur.execute('UPDATE employee SET f_name = %s, l_name = %s WHERE id = %s', (f_name, l_name, int(id)))
    mysql.connection.commit()
    cur.close()
    return jsonify({
        'status':'success',
        'f_name':f_name,
        'l_name':l_name})


@app.route('/delete/<string:id>', methods=['DELETE'])
def delete():
    cur = mysql.connection.cursor()
    cur.execute('DELETE FROM employee WHERE id = %s', (int(id)))
    mysql.connection.commit()
    cur.close()
    return jsonify({'status': 'deleted succefully'})


if __name__ == '__main__':
    app.run()





