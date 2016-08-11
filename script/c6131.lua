--パッチワーク・ファーニマル
--Fluffal Patchwork
--Scripted by Eerie Code
function c6131.initial_effect(c)
	--Frightfur
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(0xad)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c6131.subcon)
	e2:SetValue(c6131.subval)
	c:RegisterEffect(e2)
end

function c6131.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE)
end
function c6131.subval(e,c)
	return c:IsSetCard(0xad)
end
