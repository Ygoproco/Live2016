--Earthbound Prisoner Ground Keeper
function c511002987.initial_effect(c)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c511002987.indtg)
	e4:SetCountLimit(1)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c511002987.indtg(e,c)
	return c:IsSetCard(0x21f) or c:IsSetCard(0x21) or c:IsCode(67105242) or c:IsCode(67987302)
end
