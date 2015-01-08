
with general_defs; use general_defs;

package d_tsimbols is
    pragma pure;

    type tsimbols is limited private; 

    type iterador_index is private;
    type iterador_arg is private;

    -- Operacions generals
	procedure empty(ts: out tsimbols);
    procedure put(ts: in out tsimbols; id: in id_nom; d: in descripcio; error: out boolean);
    function get(ts: in tsimbols; id: in id_nom) return descripcio;


	-- Operacions de record
    procedure put_camp(ts: in out tsimbols; idr,idc: in id_nom; d: in descripcio; error: out boolean); --idr: id record , idc: id camp
    function get_camp(ts: in tsimbols; idr,idc: in id_nom) return descripcio;
    procedure update(ts: in out tsimbols; id: in id_nom; d: in descripcio);


	-- Operacions d'array
    procedure put_index(ts: in out tsimbols; ida: in id_nom; di: in descripcio);
    procedure first(ts: in tsimbols; ida: in id_nom; it: in iterador_index);
    procedure next(ts: in tsimbols; it: in out iterador_index);
    function get(ts: in tsimbols; it: in iterador_index) return descripcio;
    function is_valid(it: in iterador_index) return boolean;


	-- Operacions de procediment
    procedure put_arg(ts: in out tsimbols; idp,ida: in id_nom; da: in descripcio; error: out boolean);
    procedure first(ts: in tsimbols; idp: in id_nom; it: out iterador_arg);
    procedure next(ts: in tsimbols; it in out iterador_arg);
    procedure get(ts: in tsimbols; it: in iterador_arg; ida: out id_nom; da: out descripcio);
    function is_valid(it: in iterador_arg) return boolean;
    
    
	-- Operacions del compilador! :)
    procedure enter_block(ts: in out tsimbols);
    procedure exit_bock(ts: in out tsimbols);


    no_es_tipus, no_es_record, no_es_array, no_es_proc, mal_us: exception;
    
private
    
    type index_expansio is integer range 0..max_id;
    
    type te_item;
    type td_item is
        record
            prof: integer;
            d: descripcio;
            next: index_expansio;
        end record;

    type te_item is 
        record
            id: id_nom;
            prof: integer;
            d: descripcio;
            next: index_expansio;
        end record;

    --!!!los rangos no estan bien puestos!!!
    type tdescripcio is array (id_nom) of td_item;
    type texpansio is array (index_expansio) of te_item;
    type tblocks is array (id_nom) of index_expansio;

    type tsimbols is 
        record
            prof: integer;
            td: tdescripcio;
            te: texpansio;
            tb: tblocks;
        end record;

    
    type iterador_index is index_expansio;
    type iterador_arg is index_expansio;

end d_tsimbols;
