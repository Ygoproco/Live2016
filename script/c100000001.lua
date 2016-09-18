--手をつなぐ魔人
function c100000001.initial_effect(c)
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetTarget(c100000001.tglimit)
	c:RegisterEffect(e1)
	--defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c100000001.val)
	c:RegisterEffect(e2)
end
function c100000001.tglimit(e,c)
	return c~=e:GetHandler()
end
function c100000001.val(e,c)
	local def=0
	local g=Duel.GetMatchingGroup(Card.IsPosition,c:GetControler(),LOCATION_MZONE,0,c,POS_FACEUP_DEFENSE)
	local tc=g:GetFirst()
	while tc do
		local cdef=tc:GetBaseDefense()
		def=def+(cdef>=0 and cdef or 0)
		tc=g:GetNext()
	end
	return def
end
