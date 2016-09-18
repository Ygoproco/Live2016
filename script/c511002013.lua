--Idaten, the Star of Supreme Victory
function c511002013.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c511002013.ffilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x407),true)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511002013.atkcon)
	e1:SetOperation(c511002013.atkop)
	c:RegisterEffect(e1)
end
function c511002013.ffilter(c)
	return c:IsFusionSetCard(0x408) or c:IsFusionSetCard(0x21f) or c:IsFusionSetCard(0x21) or c:IsFusionCode(67105242) or c:IsFusionCode(67987302)
end
function c511002013.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and c:GetLevel()>=bc:GetLevel() and bc:IsControler(1-tp)
end
function c511002013.atkop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(0)
		bc:RegisterEffect(e1)
	end
end
