--Supreme Thunder Star Raijin
function c511002014.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c511002014.ffilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x407),true)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
end
function c511002014.ffilter(c)
	return c:IsFusionSetCard(0x408) or c:IsFusionSetCard(0x21f) or c:IsFusionSetCard(0x21) or c:IsFusionCode(67105242) or c:IsFusionCode(67987302)
end
