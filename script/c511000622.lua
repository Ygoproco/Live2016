--Harmonia Mirror
function c511000622.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCondition(c511000622.condition)
	e1:SetOperation(c511000622.activate)
	c:RegisterEffect(e1)
end
function c511000622.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:GetSummonType()~=SUMMON_TYPE_SYNCHRO and tc:IsType(TYPE_SYNCHRO) and tc:IsAbleToChangeControler() and ep~=tp
end
function c511000622.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsFaceup() and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
