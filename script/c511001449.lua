--Adapt to Adversity
function c511001449.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511001449.limcon)
	e2:SetOperation(c511001449.limop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
end
function c511001449.limfilter(c,tp)
	return c:IsControler(tp)
end
function c511001449.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511001449.limfilter,1,nil,tp)
end
function c511001449.limop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511001449.limfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetValue(c511001449.indesval)
		e3:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c511001449.indesval(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
