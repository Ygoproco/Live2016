--天声の服従
function c39238953.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c39238953.cost)
	e1:SetTarget(c39238953.target)
	e1:SetOperation(c39238953.activate)
	c:RegisterEffect(e1)
end
function c39238953.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c39238953.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil)
		or Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local lp=true
	while lp do
		ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
		local tk=Duel.CreateToken(tp,ac)
		if tk:IsType(TYPE_MONSTER) then lp=false end
	end
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c39238953.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if g:GetCount()<1 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,526)
	local sg=g:FilterSelect(1-tp,Card.IsCode,1,1,nil,ac)
	local tc=sg:GetFirst()
	if tc then
		Duel.ConfirmCards(tp,sg)
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK,tp)
		local sel=0
		if b1 and b2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,555)
			sel=Duel.SelectOption(1-tp,aux.Stringid(39238953,0),aux.Stringid(39238953,1))+1
		elseif b1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,555)
			sel=Duel.SelectOption(1-tp,aux.Stringid(39238953,0))+1
		elseif b2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,555)
			sel=Duel.SelectOption(1-tp,aux.Stringid(39238953,1))+2
		end
		if sel==1 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_SEND_REPLACE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetTarget(c39238953.reptg)
			e1:SetOperation(c39238953.repop)
			sg:GetFirst():RegisterEffect(e1)
			sg:GetFirst():RegisterFlagEffect(39238953,0,0,1)
		elseif sel==2 then
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		end
	end
	Duel.ShuffleDeck(1-tp)
end
function c39238953.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(39238953)>0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c39238953.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(39238953)
	Duel.SendtoGrave(e:GetHandler(),e:GetHandler():GetReason(),e:GetHandler():GetOwner())
end
