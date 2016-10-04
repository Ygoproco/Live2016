--バトル・スタン・ソニック
function c511001025.initial_effect(c)
	--active
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511001025.condition)
	e1:SetOperation(c511001025.activate)
	c:RegisterEffect(e1)
end
function c511001025.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c511001025.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001025.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsFaceup() and tc:IsAttackable() and Duel.NegateAttack() then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.GetMatchingGroup(c511001025.filter,tp,LOCATION_HAND,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(525110,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
