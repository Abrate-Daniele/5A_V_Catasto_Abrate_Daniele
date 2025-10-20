let h3, h4, main, loginForm, loginMessage;

function qs(sel){ return document.querySelector(sel); }

function formatImmobileRow(imm){
    var div = document.createElement('div');
    div.className = 'immobile';
    var title = document.createElement('div');
    title.innerText = imm.indirizzo + ' in ' + imm.comune + ' — ' + imm.superficie_mq + ' mq — ' + imm.categoria + ' — rendita ' + imm.rendita_euro + '€';
    div.appendChild(title);

    var mapa = document.createElement('a');
    mapa.target = '_blank';
    var sup = parseFloat(imm.superficie_mq);
    var cls = 'grande';
    if(!isNaN(sup)){
        if(sup < 50) cls = 'piccola';
        else if(sup < 90) cls = 'media';
        else cls = 'grande';
    }
    mapa.className = cls;
    mapa.href = 'img/' + cls + '.png';
    div.appendChild(mapa);

    if(imm.titolarita && imm.titolarita == 'Proprietà per 1/2'){
        div.classList.add('pmezza');
    }

    div.addEventListener('click', function(){
        var prev = document.querySelector('.immobile.selected');
        if(prev) prev.classList.remove('selected');
        div.classList.add('selected');
        window._selectedImmobile = imm;
    });

    return div;
}

function openModifyDialog(imm){
    const dlg = document.createElement('dialog');
    dlg.innerHTML = `
        <form method="dialog">
            <label>Categoria: <input name="categoria" value="${imm.categoria}"/></label><br/>
            <label>Rendita: <input name="rendita_euro" value="${imm.rendita_euro}"/></label><br/>
            <label>Superficie: <input name="superficie_mq" value="${imm.superficie_mq}"/></label><br/>
            <menu>
                <button id="save">Salva</button>
                <button id="cancel">Annulla</button>
            </menu>
        </form>`;
    document.body.appendChild(dlg);
    dlg.showModal();
    dlg.querySelector('#save').addEventListener('click', function(ev){
        ev.preventDefault();
        var form = dlg.querySelector('form');
        var categoriaInput = form.querySelector('input[name="categoria"]');
        var renditaInput = form.querySelector('input[name="rendita_euro"]');
        var superficieInput = form.querySelector('input[name="superficie_mq"]');
        var data = { action: 'modificaImmobile', id: imm.id, categoria: categoriaInput ? categoriaInput.value : null, rendita_euro: renditaInput ? parseFloat(renditaInput.value) : null, superficie_mq: superficieInput ? parseFloat(superficieInput.value) : null };
        fetch('backend/router.php', {method: 'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(data)})
        .then(function(r){ return r.json(); }).then(function(j){ if(j.ok){ alert('Salvataggio avvenuto con successo.'); dlg.close(); dlg.remove(); loadImmobili(); } else if(j.error){ alert('Errore: '+j.error); } }).catch(function(e){ alert('network error'); });
    });
    dlg.querySelector('#cancel').addEventListener('click', function(){ dlg.close(); dlg.remove(); });
}

function requestAvviso(id){
    fetch('backend/router.php', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({action:'inviaAvvisoPagamento', id:id})})
    .then(function(r){ if(r.status===403){ window.location.reload(); throw new Error('session_expired'); } return r.json(); })
    .then(function(j){ if(j.ok){ var av = j.avviso; alert('Avviso per immobile '+av.id+'\n'+av.indirizzo+', '+av.comune+'\nCategoria: '+av.categoria+'\nRendita: '+av.rendita_euro+'€\nIMU da pagare: '+av.imu_da_pagare+'€'); loadImmobili(); } else alert('Errore: '+(j.error||'unknown')); })
    .catch(function(e){ if(e.message!=='session_expired') console.error(e); });
}

function renderImmobili(list){
    main.innerHTML = '';
    list.forEach(function(i){ main.appendChild(formatImmobileRow(i)); });
}

function loadImmobili(){
    fetch('backend/router.php?action=getImmobili').then(function(r){ if(r.status===403){ window.location.reload(); throw new Error('session_expired'); } return r.json(); }).then(function(j){ if(j.ok) renderImmobili(j.immobili); else console.error(j); }).catch(function(e){ console.error(e); });
}

window.addEventListener('DOMContentLoaded', function(){
    h3 = qs('h3'); h4 = qs('h4'); main = qs('main'); loginForm = qs('#loginForm'); loginMessage = qs('#loginMessage');

    loginForm.addEventListener('submit', function(ev){
        ev.preventDefault();
        var form = new FormData(loginForm);
        var payload = { action:'login', codice_fiscale: form.get('codice_fiscale') };
        fetch('backend/router.php', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(payload)})
        .then(function(r){ return r.json(); }).then(function(j){ if(j.ok){ loginMessage.innerText = 'Accesso effettuato: '+j.user.nome+' '+j.user.cognome; qs('#loginSection').style.display = 'none'; h3.innerText = 'Utente: '+j.user.nome+' '+j.user.cognome; loadImmobili(); } else { loginMessage.innerText = 'Errore: '+(j.error||'login failed'); } }).catch(function(e){ loginMessage.innerText = 'Network error'; });
    });
    var nav = document.querySelector('nav');
    if(nav){
        if(nav.children[0]) nav.children[0].addEventListener('click', function(){
            var sel = window._selectedImmobile || null;
            if(!sel) { alert('Seleziona prima un immobile'); return; }
            openModifyDialog(sel);
        });
        if(nav.children[2]) nav.children[2].addEventListener('click', function(){
            var sel = window._selectedImmobile || null;
            if(!sel) { alert('Seleziona prima un immobile'); return; }
            requestAvviso(sel.id);
        });
    }
});