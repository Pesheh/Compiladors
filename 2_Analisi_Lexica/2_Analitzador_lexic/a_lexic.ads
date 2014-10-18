with d_token; use d_token;
package a_lexic is 
	procedure open(name: in String);
	procedure close;
	function YYLex return Token;	-- YYText?
end a_lexic;
