--バブル・クラッシュ
function c61622107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(c61622107.condition)
	e1:SetOperation(c61622107.activate)
	c:RegisterEffect(e1)
end
function c61622107.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0xe,0)>=6 or Duel.GetFieldGroupCount(tp,0,0xe)>=6
end
function c61622107.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local ct=Duel.GetFieldGroupCount(p,0xe,0)
	if ct>=6 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(p,nil,p,0xe,0,ct-5,ct-5,e:GetHandler())
		Duel.SendtoGrave(g,REASON_RULE)
	end
	ct=Duel.GetFieldGroupCount(1-p,0xe,0)
	if ct>=6 then
		Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-p,nil,1-p,0xe,0,ct-5,ct-5,e:GetHandler())
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
