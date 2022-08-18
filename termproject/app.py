import psycopg2
from flask import Flask, render_template, request

app = Flask(__name__)
connect = psycopg2.connect("dbname=project2 user=postgres password=9240")
cur = connect.cursor()  # create cursor

@app.route('/')
def main():
    return render_template("main.html")


@app.route('/return', methods=['post'])
def re_turn():
    return render_template("main.html")


@app.route('/print_table', methods=['post'])
def print_table():
    cur.execute("SELECT * FROM users;")
    result = cur.fetchall()

    return render_template("print_table.html", users=result)


@app.route('/register', methods=['post'])
def register():
    id = request.form["id"]
    password = request.form["password"]
    send = request.form["send"]
    
    if id == '' or password == '' :
        return render_template("empty_idpw.html")

    if send == "sign up" : 
        cur.execute("SELECT id FROM users;")
        result = cur.fetchall()
        
        if (id,) in result :
            return render_template("ID_collision.html")
        else :
            return render_template("signup.html", id = id, password = password) 

    if send == "sign up2" :
        pw2nd = request.form["pw2nd"]
        hint = request.form["hint"]

        if pw2nd == '' or hint == '' : 
            return render_template("empty_pw2ndhint.html", id = id, password = password)

        cur.execute("INSERT INTO users VALUES('{}', '{}', '{}', '{}');".format(id, password, pw2nd, hint))
        cur.execute("insert into account values('{}', '{}', '{}');".format(id, 10000, 'beginner'))
        connect.commit() 
        return render_template("signup_success.html")
    if send == "login" :
        cur.execute("SELECT id, password FROM users;")
        result = cur.fetchall()
        if (id, password) in result : 
            cur.execute("select * from account where id = '{}';".format(id))
            userinfo = cur.fetchall()
            cur.execute("with code_total(code, total) as (select code, count(code) from trade group by code) select type from code_total, category where code_total.code = category.code and total = (select max(total) from code_total)")
            category = cur.fetchall()
            cur.execute("with buyer_total(buyer, total) as (select buyer, sum(trade_price) from trade group by buyer) select buyer from buyer_total where total = (select max(total) from buyer_total)")
            buyer = cur.fetchall()
            cur.execute("with seller_total(seller, total) as (select seller, sum(trade_price) from trade group by seller) select seller from seller_total where total = (select max(total) from seller_total)")
            seller = cur.fetchall()
            cur.execute("select * from items")
            items = cur.fetchall()
            connect.commit() 
            return render_template("login_action.html", user = userinfo, category = category, buyer = buyer, seller = seller, password = password, items = items)
        else : 
            return render_template("login_fail.html")           
    return render_template("signup_success.html")


@app.route('/admin', methods=['post'])
def admin():
    id = request.form["id"]
    password = request.form["password"]
    send = request.form["send"]

    if id != "admin" : 
        return render_template("admin_fail.html", id = id, password = password)

    if send == "users info" : 
        cur.execute("SELECT * FROM users;")
        connect.commit() 
        result = cur.fetchall()
        return render_template("admin_success_users.html", id = id, password = password, infos=result)
    elif send == "trades info" : 
        cur.execute("SELECT * FROM trade;")
        connect.commit() 
        result = cur.fetchall()
        return render_template("admin_success_trades.html", id = id, password = password, infos=result)
    
    return render_template("main.html")

@app.route('/add', methods=['post'])
def add() :
    send = request.form["send"]
    id = request.form["id"]
    password = request.form["password"]

    if send == "open_add" :     
        cur.execute("select * from category;")
        connect.commit() 
        category = cur.fetchall()
        return render_template("add.html", id = id, password = password, category = category)
    elif send == "add" :
        code = request.form["code"]
        name = request.form["name"]
        price = request.form["price"]
        stock = request.form["stock"]
        
        if code == '' or name == '' or price == '' or stock == '' :
            return render_template("empty_add.html", id = id, password = password)
        
        cur.execute("select * from category where code = '{}';".format(code))
        result = cur.fetchall()
        if result == [] : 
            return render_template("add_error.html", id = id, password = password, reason = "code")
        if not price.isnumeric() or not stock.isnumeric(): 
            return render_template("add_error.html", id = id, password = password, reason = "price/stock")
        elif int(stock) <= 0 or int(price) < 0 :
            return render_template("add_error.html", id = id, password = password, reason = "price/stock")
        
        cur.execute("select stock from items where code = '{}' and name = '{}' and price = {} and seller = '{}';".format(code, name, price, id))
        result = cur.fetchall()

        if result == [] : 
            cur.execute("insert into items values('{}', '{}', {}, {}, '{}');".format(code, name, price, stock, id))
            connect.commit() 
        else :
            cur.execute("update items set stock = stock + {} where code = '{}' and name = '{}' and price = {} and seller = '{}';".format(stock, code, name, price, id))
            connect.commit() 
        return render_template("add_success.html", id = id, password = password)



@app.route('/buy', methods=['post'])
def buy() :     
    send = request.form["send"]
    id = request.form["id"]
    password = request.form["password"]
    
    if send == "open_buy" : 

        code = request.form["code"]
        name = request.form["name"]
        price = request.form["price"]
        stock = request.form["stock"]
        seller = request.form["seller"]

        cur.execute("select balance from account where id = '{}';".format(id))
        balance = cur.fetchall()[0][0]
        cur.execute("select rating from account where id = '{}';".format(id))
        rating = cur.fetchall()[0][0]
        
        connect.commit()
        return render_template("buy.html", id = id, password = password, balance = balance, rating = rating, code = code, name = name, price = price, stock = stock, seller = seller)
    
    elif send == "buy" : 

        paystock = int(request.form["paystock"])
        
        balance = int(request.form["balance"])
        rating = request.form["rating"]

        code = request.form["code"]
        name = request.form["name"]
        price = int(request.form["price"])
        stock = int(request.form["stock"])
        seller = request.form["seller"]

        if not request.form["paystock"].isnumeric() or paystock == 0 : 
            return render_template("buying_fail.html", id = id, password = password, code = code, name = name, price = price, stock = stock, seller = seller, reason = "0보다 큰 정수형만 입력할 수 있습니다.")
        if paystock > stock :
            return render_template("buying_fail.html", id = id, password = password, code = code, name = name, price = price, stock = stock, seller = seller, reason = "재고가 충분하지 않습니다.")
        else :
            cur.execute("select discount from rating_info where rating = '{}';".format(rating))
            discount = cur.fetchall()[0][0]
            connect.commit()
            
            total_price = price * paystock
            discount_price = total_price * discount / 100
            final_price = total_price - discount_price
            
            if final_price > balance : 
                return render_template("buying_fail.html", id = id, password = password, code = code, name = name, price = price, stock = stock, seller = seller, reason = "잔고가 충분하지 않습니다.")
            return render_template("buying.html", id = id, password = password, balance = balance, rating = rating, code = code, name = name, price = price, stock = stock, seller = seller, paystock = paystock, total_price = total_price, discount_price = discount_price, final_price = final_price)

@app.route('/confirm', methods=['post'])
def confirm() : 
    pw2nd = request.form["pw2nd"]
    id = request.form["id"]
    password = request.form["password"]
    seller = request.form["seller"]

    code = request.form["code"]
    name = request.form["name"]
    price = int(request.form["price"])
    stock = int(request.form["stock"])
    seller = request.form["seller"]        
    paystock = int(request.form["paystock"])

    total_price = int(request.form["total_price"])
    final_price = float(request.form["final_price"])

    cur.execute("select pw2nd from users where id = '{}';".format(id))
    result = cur.fetchall()[0][0]

    if pw2nd != result : 
        return render_template("buying_fail.html", id = id, password = password, code = code, name = name, price = price, stock = stock, seller = seller, reason = "2차 비밀번호가 틀립니다!.")

    cur.execute("update account set balance = balance - {} where id = '{}';".format(final_price, id))
    cur.execute("update account set balance = balance + {} where id = '{}';".format(total_price, seller))
    cur.execute("update account set rating = case when balance < (select condition from rating_info where rating = 'bronze') then 'beginner' when balance < (select condition from rating_info where rating = 'silver') then 'bronze' when balance < (select condition from rating_info where rating = 'gold') then 'silver' else 'gold' end where id = '{}' or id = '{}';".format(id, seller))
    
    cur.execute("insert into trade values('{}', '{}', '{}', {});".format(id, seller, code, total_price))
    
    if stock == paystock :
        cur.execute("delete from items where code = '{}' and name = '{}' and price = {} and seller = '{}';".format(code, name, price, seller))
    else : 
        cur.execute("update items set stock = stock - {} where code = '{}' and name = '{}' and price = {} and seller = '{}';".format(paystock, code, name, price, seller))
    
    connect.commit()
    return render_template("confirm_success.html", id = id, password = password)

@app.route('/findpw', methods=['post'])
def findpw() : 
    send = request.form["send"]
    if send == "open_findpw" : 
        return render_template("findpw.html")

    elif send == "find" : 
        id = request.form["id"]
        hint = request.form["hint"]

        if id == '' or hint == '' :
            return render_template("empty_findpw.html")

        cur.execute("SELECT id FROM users;")
        idlist = cur.fetchall()
        
        if (id,) not in idlist :
            return render_template("findpw_fail.html", reason = "일치하는 아이디가 없습니다!")

        cur.execute("select hint from users where id = '{}';".format(id))
        result = cur.fetchall()[0][0] 
        
        if hint != result : 
            connect.commit()
            return render_template("findpw_fail.html", reason = "비밀번호 힌트가 틀렸습니다!")
        else : 
            cur.execute("select password from users where id = '{}';".format(id))
            password = cur.fetchall()[0][0]
            connect.commit()
            return render_template("findpw_success.html", password = password)

if __name__ == '__main__':
    app.run()
