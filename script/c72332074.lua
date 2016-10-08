--超量必殺アルファンボール
--Super Quantal Finisher Alphan Ball
--Scripted by Eerie Code
function c72332074.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c72332074.condition)
	e1:SetTarget(c72332074.target)
	e1:SetOperation(c72332074.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c72332074.fdcost)
	e2:SetTarget(c72332074.fdtg)
	e2:SetOperation(c72332074.fdop)
	c:RegisterEffect(e2)
end

function c72332074.cfil(c)
	return c:IsFaceup() and c:IsSetCard(0x10dc)
end
function c72332074.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72332074.cfil,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function c72332074.fil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,true,false,POS_FACEUP,1-tp)
end
function c72332074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(c72332074.fil,tp,0,LOCATION_EXTRA,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c72332074.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		local mg=Duel.GetMatchingGroup(c72332074.fil,tp,0,LOCATION_EXTRA,nil,e,tp)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and mg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sg,0,1-tp,1-tp,true,false,POS_FACEUP)
		end
	end
end

function c72332074.fdcfil(c)
	return c:IsCode(58753372) and c:IsAbleToRemoveAsCost()
end
function c72332074.fdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c72332074.fdcfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c72332074.fdcfil,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c72332074.fdfil(c,tp)
	return c:IsCode(10424147) and c:GetActivateEffect():IsActivatable(tp)
end
function c72332074.fdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72332074.fdfil,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c72332074.fdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c72332074.fdfil,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
